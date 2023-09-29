require_relative "position.rb" 
require_relative "ship.rb"

class GameBoard
    # @max_row is an `Integer`
    # @max_column is an `Integer`

    #2D board that holds ship objects
    attr_reader :max_row, :max_column, :board, :letters, :current_letter

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column
        @board = Array.new(max_row) {Array.new(max_column)}
        #set the empty board
        for row in 0..max_row-1 do
            for col in 0..max_column-1 do
                @board[row][col] = " -, - |"
            end
        end

        @letters = "BCDEFGHIJKLMNOPQRSTUVWXYZ"
        @current_letter = 0
        @marker = @letters[0]
        @successful_attacks = 0
    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
        ship_row = ship.start_position.row - 1
        ship_col = ship.start_position.column - 1

                #make sure each initial position is within bounds
        if 
            ship_row < 0
            return false
        end
        if 
            ship_row + 1 > max_row
            return false
        end
        if
            ship_col < 0
            return false
        end
        if 
            ship_col + 1 > max_column
            return false
        end
        #make sure each orientation and size does not exceed the bounds
        if
            ship.orientation == "Up"
            #Make sure every possible tile we are trying to fit above current one is free
            if
                ship_row - ship.size + 1 < 0
                return false
            end
            
            
        end
        if
            ship.orientation == "Down"
            #Make sure every possible tile we are trying to fit below current one is free
            
            if
                (ship_row + ship.size) > max_row
                return false
            end
            
            
        end
        if
            ship.orientation == "Left"
            #Make sure every possible tile we are trying to fit left of current one is free
            if
                ship_col - ship.size + 1 < 0
                return false
            end
            
            
        end
        if
            ship.orientation == "Right"
            #Make sure every possible tile we are trying to fit left of current one is free
            if
                (ship_col + ship.size) > max_column
                return false
            end
            
            
        end

        #if this slot is free, try and fill it, otherwise return false
        
        if
            ship.orientation == "Up"
            #Make sure every possible tile we are trying to fit above current one is free
            for i in 0..ship.size-1 do
                if
                    @board[ship_row-i][ship_col][1] != "-"
                    return false
                end
            end
            
        end
        if
            ship.orientation == "Down"
            #Make sure every possible tile we are trying to fit below current one is free
            for i in 0..ship.size-1 do
                if
                    @board[ship_row+i][ship_col][1] != "-"
                    return false
                end
            end
            
        end
        if
            ship.orientation == "Left"
            #Make sure every possible tile we are trying to fit left of current one is free
            for i in 0..ship.size-1 do
                if
                    @board[ship_row][ship_col-i][1] != "-"
                    return false
                end
            end
            
        end
        if
            ship.orientation == "Right"
            #Make sure every possible tile we are trying to fit right of current one is free
            for i in 0..ship.size-1 do
                if
                    @board[ship_row][ship_col+i][1] != "-"
                    return false
                end
            end
            
        end

        #if we got here, nothing was taken, so go ahead and add it

        if
            ship.orientation == "Up"
            #Mark every tile above current one 
            for i in 0..ship.size-1 do
                @board[ship_row-i][ship_col][1] = @marker    
            end
            
        end
        if
            ship.orientation == "Down"
            #Mark every tile above current one 
            for i in 0..ship.size-1 do
                @board[ship_row+i][ship_col][1] = @marker     
            end
            
        end
        if
            ship.orientation == "Left"
            #Mark every tile above current one 
            for i in 0..ship.size-1 do
                @board[ship_row][ship_col-i][1] = @marker     
            end
            
        end
        if
            ship.orientation == "Right"
            #Mark every tile above current one 
            for i in 0..ship.size-1 do
                @board[ship_row][ship_col+i][1] = @marker    
            end
            
        end
        #Use a different letter next time
        @current_letter += 1
        @marker = letters[current_letter]
        return true
        

    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)

        attack_row = position.row - 1
        attack_col = position.column - 1
        
        #make sure each attack is within bounds
        if 
            attack_row < 0
            return nil
        end
        if 
            attack_row + 1 > max_row
            return nil
        end
        if
            attack_col < 0
            return nil
        end
        if 
            attack_col + 1 > max_column
            return nil
        end
        
        #if there was something there, mark it (even if its already hit),
        #increment the successful attack counter and return true
        if @board[attack_row][attack_col][1] != "-"

            @board[attack_row][attack_col][4] = "A"
            @successful_attacks += 1
            return true
        else
            return false
        end
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks
        return @successful_attacks
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?
        #check all tiles
        for row in 0..max_row-1 do
            for col in 0..max_column-1 do
                if @board[row][col][1] != "-" 
                    if @board[row][col][4] != "A" 
                        #if there is a ship part here, that has not been 
                        #attacked, they cannot all have sunk
                        return false
                    end
                    
                end
            end
        end
        #if no unnattacked ship parts were found, we return true,
        #because either the board is empty, or all ships have been sunk
        return true
    end

    # String representation of GameBoard (optional but recommended)
    def to_s
        for row in 1..max_column do
            print "     #{row} "
        end
        print "\n"
        for row in 0..max_row-1 do
            print "#{row+1}: "
            for col in 0..max_column-1 do
                #if theres a ship there print it
                
                print board[row][col]

            end
            print "\n"
        end
    end
end

=begin 
position1 = Position.new(11,1)
position2 = Position.new(3,3)
position3 = Position.new(8,8)
position4 = Position.new(5,1)
ship1 = Ship.new(position1, "Up", 1)
ship2 = Ship.new(position2, "Down", 2)
ship3 = Ship.new(position3, "Left", 3)
ship4 = Ship.new(position4, "Right", 2)
game = GameBoard.new(10,10)


game.add_ship(ship1)
game.add_ship(ship2)
game.add_ship(ship3)
game.add_ship(ship4)

a1 = Position.new(11,11) #nil
a2 = Position.new(1,1) #true
a3 = Position.new(2,2) #nil
a4 = Position.new(5,1) #true
a5 = Position.new(5,2) #true
a6 = Position.new(4,3) #true
a7 = Position.new(3,3) #true
a8 = Position.new(8,6) #true
a9 = Position.new(8,7) #true
a10 = Position.new(8,8) #true

puts game.attack_pos(a1) #nil
puts game.attack_pos(a2) #true
puts game.attack_pos(a3) #nil
puts game.attack_pos(a4) #true
puts game.attack_pos(a5) #true
puts game.attack_pos(a6) #true
puts game.attack_pos(a7) #true
puts game.attack_pos(a8) #true
puts game.attack_pos(a9) #true 
puts game.attack_pos(a10) #true

puts game.num_successful_attacks

puts game.all_sunk?

puts game 
=end
