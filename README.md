# Terminal Terrain Generator

## About

This application will :
1. Generate random terrain and display it in the terminal.
2. Allow user to shape the terrain by adding and removing earth, and smoothing out the terrain.
3. Allow for saving of maps, making them available for re-use. Exporting to JSON allows tile attributes to be used by other applications.
4. Generate PNG images of maps created for a quick overview of your favourite maps.

---
## System and Hardware requirements

For the best user experience, please run in a stand-alone bash terminal with:
1. font size: between 20 and 30.
2. sreen buffer size: width 120, and height at least 40
3. also recommended are default fonts and colours (developed with 'consolas' in mind)

The terminal is used as the gui for this application so to not run it with the recommended settings may affect display of the maps at small window sizes.

---
## Dependencies

This application is developed in Ruby, and requires Ruby to be installed to run. If you wish to install Ruby head on over to *[ruby-lang.org](https://www.ruby-lang.org/en/downloads/)*.

Gems:

- tty-prompt ~> 0.23.1

- tty-progressbar ~> 0.18.2

- chunky_png ~> 1.4

- rainbow ~> 3.0

---
## Installation

The installation and running of this terrain generator is managed by the "./terra" file.

To *Install* please navigate to the main directory and enter **'./terra'**. Installation of dependencies will be taken care of when you select the install dependencies option; follow the prompts and press 'i'.

*Run* the application in the same way, type './terra' and press enter. Now instead of installing dependencies, follow the prompts and press 'r' to run the application.

*Clear* the maps folder by following the prompts and selecting 'c'.

Please Note that should one wish to bypass the bash script entirely to begin the application, one MUST install dependencies and then pass the 'run' or 'clear' command line argument when opening 'main.rb' with ruby.

for example.

    gem install bundler (if you do not have bundler installed)

    bundle install (to install dependencies)

    ruby main.rb run (to run application)

    ruby main.rb clear (to clear maps)

