## Plot

This simple protocol is used to control the Bot via WLAN. This protocol is based on TCP over Wireless LAN (802.11a/b/g/n/ac). This protocol is command-based, each packet will contain one command that needed to be executed remotely by the Bot.

Default port that Bot will listen on is 80. Any incoming connection will make Bot change state. See bellow states section for more information.

## Bot states

| State           | Onboard LED | Explain                                                                                                                                  |
|-----------------|-------------|------------------------------------------------------------------------------------------------------------------------------------------|
| WLAN Connecting | Off         | This is the first state, once Bot is turned on. It will look for network specified in config (should be flashed along with source code). |
| Waiting         | Off         | After connected to WLAN. Bot will stand by, and waiting for incoming connection on port 80 (config in init.lua).                         |
| Online          | On          | Remote device connected to BOT's TCP port. LED will be bright to indicate that connection was successful.                                |

![State diagram](https://raw.githubusercontent.com/minhnhut/esp8266-remote-control-bot/master/Software/Protocol/imgs/ESP8226_State.jpg)

## Connection - Handshake

Use any favorite TCP client, and connect to BOT's 80 port. Make sure that BOT and Client machine is on same WLAN.

After connection is confirmed, BOT should change state as mentioned in above section. LED will be on. And a welcome message will be sent back from Bot via TCP. From now on, bot is ready to take a Command.

## Commands

One command indicate if motors should stand by, or spin in a specified direction. Command is encoded as a STRING that contains two DIGITs. Each DIGIT indicate a state of a motor.

| Code | Meaning                                                      |
|------|--------------------------------------------------------------|
| 0    | Stand by. No motion. Motor stopped. (One motor)              |
| 1    | Spin clockwise (Maybe opposite, depend on your setup)        |
| 2    | Spin counterclockwise (Maybe opposite, depend on your setup) |

Example commands:

| Command | Explain                                                                        |
|---------|--------------------------------------------------------------------------------|
| 00      | Both motor standing by. No motion.                                             |
| 11      | Move forward.                                                                  |
| 12      | Motors spin forward different directions. Result in Bot spins round and round. |
| 10      | One motor spin, the other stop. Result in Bot take a turn. (Right turn)        |

Once command received, Bot will continue excuting command until next command is received. Command 00 should be sent to make BOT stop moving.

## To be improved

I'm planing to add ultra sonic module as bot's head, which can be spinned also. I'm gonna need another code to control that.
