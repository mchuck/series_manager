""" Build script for the app """

import os

from subprocess import call
from termcolor import colored
from shutil import copytree, copy, rmtree


APP_NAME = "SeriesManager"

APP_PLATFORM = "linux,win32"


print colored("BUILDING F# Suave server", 'green')

call(["./build.sh"])

print colored("DELETING ./dist", "green")

if os.path.isdir("./dist"):
    rmtree("./dist")

print colored("DEPLOYING Electron app", 'green')

call(["electron-packager"
      , "./client/"
      , APP_NAME
      , "--platform=" + APP_PLATFORM
      , "--electron-version=1.4.13"
      , "--asar"
      , "--out=./dist/"])

print colored("COPYING server", 'green')

copytree("./build/", "./dist/" + APP_NAME + "-linux-x64/server/")
copytree("./build/", "./dist/" + APP_NAME + "-win32-x64/server/")

print colored("COPYING db", 'green')

copytree("./db/", "./dist/" + APP_NAME + "-linux-x64/db")
copytree("./db/", "./dist/" + APP_NAME + "-win32-x64/db")

print colored("DONE", 'green')
