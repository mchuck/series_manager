'use strict';
const electron = require('electron');
const spawn = require('child_process').spawn;
const chokidar = require('chokidar');

const app = electron.app; // this is our app
const BrowserWindow = electron.BrowserWindow; // This is a Module that creates windows


let mainWindow; // saves a global reference to mainWindow so it doesn't get garbage collected
let server;

app.on('ready', init); // called when electron has initialized

// tell chokidar to watch these files for changes
// reload the window if there is one
chokidar.watch(['ports.js', 'index.html', 'elm.js', '**/*.css']).on('change', () => {
  if (mainWindow) {
      mainWindow.reload();
  }
});

// This will create our app window, no surprise there

function init(){
    spawnServer();
    createWindow();
}

function spawnServer() {
    server = spawn('mono', ['../build/server.exe']);

    server.on('exit', (data) => {
	console.log(data);
    });
    server.stdout.on('data', (data) => {
	var str = String.fromCharCode.apply(null, data);
	console.log(str);
    });

    server.stderr.on('data', (data) => {
	var str = String.fromCharCode.apply(null, data);
	console.log(str);
    });
}

function createWindow () {
  mainWindow = new BrowserWindow({
      width: 800, 
      height: 600,
      minHeight : 400,
      minWidth : 600
  });

  // display the index.html file
    mainWindow.loadURL(`file://${ __dirname }/index.html`);
  
  // open dev tools by default so we can see any console errors
  //mainWindow.webContents.openDevTools();

  mainWindow.on('closed', function () {
      mainWindow = null;
  });
}

/* Mac Specific things */

// when you close all the windows on a non-mac OS it quits the app
app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit();
    }
});

app.on('before-quit', () => {
    server.kill();
});

// if there is no mainWindow it creates one (like when you click the dock icon)
app.on('activate', () => {
    if (mainWindow === null) {
        createWindow();
    }
});
