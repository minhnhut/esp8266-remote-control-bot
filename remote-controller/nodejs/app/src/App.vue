<template>
    <div id='app'>
        <template v-if="!connected">
            <input type="text" v-model="host">
            <input type="text" v-model="port">
            <b-button @click="connect">Connect</b-button>
        </template>
        <template v-else>
            <p>Connected</p>
            <p>press arrow key to navigate</p>

            <b-row>
                <b-col></b-col>
                <b-col>
                    <b-button :class="{invisible: forward!==1}" disabled>　↑　</b-button>
                </b-col>
                <b-col></b-col>
            </b-row>
            <b-row>
                <b-col><b-button :class="{invisible: spin!==-1}" disabled>　←　</b-button></b-col>
                <b-col><b-button :class="{invisible: forward!==-1}" disabled>　↓　</b-button></b-col>
                <b-col><b-button :class="{invisible: spin!==1}" disabled>　→　</b-button></b-col>
            </b-row>
        </template>
    </div>
</template>

<script>
    import Hello from './components/Hello.vue'
import { setInterval } from 'timers';

    // With shell.openExternal(url) is how
    // external urls must be handled, not href
    const shell = require('electron').shell
    const ipc = require('electron').ipcRenderer;

    export default {
        components: {
            Hello
        },
        data: () => ({
            host: "192.168.2.106",
            port: "80",
            connected: false,
            forward: 0,
            spin: 0
        }),
        methods: {
          connect() {
              ipc.send("tcp-connect", {host: this.host, port: this.port});
          },
          sendCommand(code) {
              console.log("-");
              ipc.send("tcp-command", code);
          }
        },
        mounted() {
            ipc.on("tcp-connected", () => {
                this.connected = true;
            });

            ipc.on("tcp-disconnected", () => {
                this.connected = false;
            });

            window.addEventListener("keydown", e => {
                switch (e.keyCode) {
                    case 38: // up
                        this.forward = 1;
                        break;
                    case 40: // down
                        this.forward = -1;
                        break;
                    case 37: // left
                        this.spin = -1;
                        break;
                    case 39: // right
                        this.spin = 1;
                        break;
                }
            });

            window.addEventListener("keyup", e => {
                switch (e.keyCode) {
                    case 38: // up
                        this.forward = 0;
                        break;
                    case 40: // down
                        this.forward = 0;
                        break;
                    case 37: // left
                        if (this.spin == -1) {
                            this.spin = 0;
                        }
                        break;
                    case 39: // right
                        if (this.spin == 1) {
                            this.spin = 0;
                        }
                        break;
                }
            });

            window.setInterval(() => {
                let command = [0, 0];
                switch (this.forward) {
                    case 1:
                        command = [2, 2]; 
                        break;
                    case -1:
                        command = [1, 1]; 
                        break;                    
                }

                switch (this.spin) {
                    case -1:
                        if (this.forward !== 0) {
                            command[0] = 0;
                        } else {
                            command = [1, 2];
                        }
                        break;
                    case 1:
                        if (this.forward !== 0) {
                            command[1] = 0;
                        } else {
                            command = [2, 1];
                        }
                        break;
                }
                this.sendCommand(command.join(""));
            }, 50);
        }
    }
</script>

<style>
    html {
        height: 100%;
    }
    body {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
        margin: auto;
    }
    #app {
        color: #2c3e50;
        max-width: 600px;
        font-family: Source Sans Pro, Helvetica, sans-serif;
        text-align: center;
    }
    #app a {
        color: #42b983;
        text-decoration: none;
    }
    #app p {
        text-align: justify;
    }
    .logo {
        width: auto;
        height: 100px;
    }
</style>
