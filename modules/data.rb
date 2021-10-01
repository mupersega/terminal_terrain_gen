# frozen_string_literal: true

module Data
  # Tile information
  module TileData
    def  self.tile_info
      {
        water_shallow: {
          frames: [
            "~  ",
            " ~ ",
            "~ ~"
          ],
          colour: 'blue',
          char_col: 'mediumblue'
        },
        water_medium: {
          frames: [
            " _-",
            "- _",
            "_ -"
          ],
          colour: 'mediumblue',
          char_col: 'blue'
        },
        water_deep: {
          frames: [
            " _-",
            "- _",
            "_ -"
          ],
          colour: 'midnightblue',
          char_col: 'blue'
        },
        land_peak: {
          frames: [
            "/\\^",
            "^/\\",
            "/^\\"
          ],
          colour: 'webgray',
          char_col: 'darkslategray'
        },
        land_mountain: {
          frames: [
            "  ^",
            "^  ",
            "^ ^"
          ],
          colour: 'darkslategray',
          char_col: 'gray'
        },
        land_highland: {
          frames: [
            ".  ",
            "' .",
            " ' "
          ],
          colour: 'darkgreen',
          char_col: 'green'
        },
        land_grassland: {
          frames: [
            ".  ",
            "' .",
            " ' "
          ],
          colour: 'green',
          char_col: 'lawngreen'
        },
        land_shore: {
          frames: [
            "░ ░",
            "░░ ",
            " ░░"
          ],
          colour: 'green',
          char_col: 'lightgoldenrod'
        }
      }
    end
  end
  module Text
    def self.title_ascii
      return "
          +-+-+ +-+-+-+-+-+-+-+ +-+-+-+
          |2|d| |T|e|r|r|a|i|n| |G|e|n|
          +-+-+ +-+-+-+-+-+-+-+ +-+-+-+
      "
    end
    def self.main_menu_ascii
      "
                  -main menu-
      "
    end
    def self.home_text
      "
    Welcome to the 2D terrain generation tool

  This terminal application randomly generates
    a map full of tiles, each one a different
              kind of terrain.

  These maps are able to be saved and loaded
  locally so that as long as you know how to
  import JSON, you might use the tile maps in
      your own application. Enjoy.
"
    end
  end

  # Functions used at runtime
  module RuntimeFunx
    # basic puts func
    def wrong_input
      puts "Running this application also requires a command line argument\n
      I strongly recommend that you \n
      to clear maps folder => ./terra clear"
    end

    # run specified task
    def run_task(task)
      case task
      when 'run'
        launcher = Launcher.new
        launcher.main_loop
      when 'clear'
        dir_path = './maps'
        FileUtils.rm_rf(Dir["#{dir_path}/*"], secure: true)
        puts 'clearing maps folder'
      end
    end
  end
end

# shore pale goldenrod
