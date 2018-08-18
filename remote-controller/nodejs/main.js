// Basic init
const electron = require('electron')
const {app, BrowserWindow} = electron
const net = require("net");

let socket = null;
let commandInEffect = null;

// Let electron reloads by itself when webpack watches changes in ./app/
require('electron-reload')(__dirname)
const ipc = require("electron").ipcMain;

// To avoid being garbage collected
let mainWindow

app.on('ready', () => {

    let mainWindow = new BrowserWindow({width: 800, height: 600})

    mainWindow.loadURL(`file://${__dirname}/app/index.html`)

    ipc.on("tcp-connect", (event, args) => {
        socket = new net.Socket();
        socket.connect(args.port, args.host);

        socket.on("error", () => {
            console.log("can not connect to host")
        });

        socket.on("connect", () => {
            console.log("connected");
            event.sender.send('tcp-connected');
        });

        socket.on("close", () => {
            socket = null;
            console.log("disconected");
            mainWindow.send("tcp-disconnected");
        });

        socket.write("00"); // reset current command, if there is any
    });

    ipc.on("tcp-command", (event, command) => {
        if (socket) {
            if (commandInEffect !== command) {
                socket.write(command);
            }
            commandInEffect = command;
        }
    })
})
