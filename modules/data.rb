
module Data
  module TileData
   def  self.tile_info 
    return {
      water_shallow: {
        frames: [
          "~ ~",
          " ~~",
          "~~ "
        ],
        colour: "blue",
        char_col: "mediumblue"
      },
      water_medium: {
        frames: [
          "~ ~",
          " ~~",
          "~~ "
        ],
        colour: "mediumblue",
        char_col: "blue"
      },
      water_deep: {
        frames: [
          "~ ~",
          " ~~",
          "~~ "
        ],
        colour: "midnightblue",
        char_col: "blue"
      },
      land_peak: {
        frames: [
          "^ ^",
          "^^ ",
          " ^^"
        ],
        colour: "webgray",
        char_col: "darkslategray"
      },
      land_mountain: {
        frames: [
          ".^.",
          "^,.",
          "..^"
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
          ".  ",
          "' .",
          " ' "
        ],
        colour: "goldenrod",
        char_col: "lightgoldenrod"
      }
      }
    end
  end
end

# shore pale goldenrod
