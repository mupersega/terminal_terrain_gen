class Display
    # Display class will prepare the user to create a world. It's main loop will first welcome the user and ask them to resize their viewport window. Ask the user to kindly set width and height on both axes.
    
    def initialize
        @world_rows = 30
        @world_columns = 30
        @world_tile_width = 3
        @display_width = @world_columns * @world_tile_width
    end
    def welcome_user
        
    end

    def check_viewport_width()
    end

    def check_viewport_height()
    end
    def main_loop
        welcome_user
        check_viewport_width
    end
end