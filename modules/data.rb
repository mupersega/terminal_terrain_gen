
module Data
  module TileData
   def  self.tile_info 
    return {
      water_shallow: {
        frames: [
          "~  ",
          " ~ ",
          "~ ~"
        ],
        colour: "blue",
        char_col: "mediumblue"
      },
      water_medium: {
        frames: [
          " _-",
          "- _",
          "_ -"
        ],
        colour: "mediumblue",
        char_col: "blue"
      },
      water_deep: {
        frames: [
          " _-",
          "- _",
          "_ -"
        ],
        colour: "midnightblue",
        char_col: "blue"
      },
      land_peak: {
        frames: [
          "/\\^",
          "^/\\",
          "/^\\"
        ],
        colour: "webgray",
        char_col: "darkslategray"
      },
      land_mountain: {
        frames: [
          "  ^",
          "^  ",
          "^ ^"
        ],
        colour: "darkslategray",
        char_col: "gray"
      },
      land_highland: {
        frames: [
          ".  ",
          "' .",
          " ' "
        ],
        colour: "darkgreen",
        char_col: "green"
      },
      land_grassland: {
        frames: [
          ".  ",
          "' .",
          " ' "
        ],
        colour: "green",
        char_col: "lawngreen"
      },
      land_shore: {
        frames: [
          "░ ░",
          "░░ ",
          " ░░"
        ],
        colour: "green",
        char_col: "lightgoldenrod"
      }
      }
    end
  end
  module Text
    def  self.all_text
      return {
        bundle_install_text: "The application will end now. Please run 'bundle install' in the root directory of this application to install all necessary dependancies. You may also need to run 'gem install bundler' if you don't currently have bundler installed. I know it's a lot to ask, but bear with me.",
        welcome_message: "Welcome, before we begin, if you haven't run 'bundle install' from this application's root directory, you will need to do that before we move on.\nHave you done that?"
      }
    end
  end

end

# shore pale goldenrod
