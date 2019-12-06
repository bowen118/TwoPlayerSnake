gui = {}

function love.load()
    currentScore1 = 0;
    currentScore2 = 0
    bestScore1 = 0;
    bestScore2 = 0;

    gameTimer = 0;

    gridXCount = 40;
    gridYCount = 25;

    love.window.setMode(40 * 15, 30 * 15);
    love.window.setTitle("Better Snake");

    cellSize = 15;

    snake1Segments = {
       {x = 3, y = 4},
       {x = 2, y = 4},
       {x = 1, y = 4},
    }

    snake2Segments = {
        {x = 38, y = 28},
        {x = 39, y = 28},
        {x = 40, y = 28},
    }

    function moveFood()
    local possibleFoodPositions = {}

        for foodX = 1, gridXCount do
            for foodY = 1, gridYCount do
                local possible = true;

                for segmentIndex, segment in ipairs(snake1Segments) do
                    if foodX == segment.x and foodY == segment.y then
                        possible = false;
                    end
                    
                    -- this just makes sure the food random change is on the board and to make sure it doesn't spawn in the snake.
                    
                    if (foodY < 4 or foodY > (30 * 15) - 45) then
                      possible = false;
                      end
                end

                if possible then
                    table.insert(possibleFoodPositions, {x = foodX, y = foodY})
                end
            end
        end

        foodPosition = possibleFoodPositions[love.math.random(1, #possibleFoodPositions)]
        foodColor = math.random(3);
    end

    moveFood();

    function reset()
        currentScore1 = 0;
        currentScore2 = 0;

        snake1Segments = {
            {x = 3, y = 4},
            {x = 2, y = 4},
            {x = 1, y = 4},
        }
        
        snake2Segments = {
            {x = 38, y = 28},
            {x = 39, y = 28},
            {x = 40, y = 28},
        }   

        directionQueue1 = {'right'} -- the starting movement is right.
        directionQueue2 = {'left'}
        snakeAlive = true;
        timer = 0;
        gui.timer = 0;
        gameTimer = 0;

        moveFood();       
    end

    reset();
end

function love.update(dt)
    timer = timer + dt;
    
    gameTimer = gameTimer + dt;

    if snakeAlive then
         if (gameTimer >= 1) then
           gui.timer = gui.timer + 1;
           -- gameTimer = 0;
           end
         
      
        local timerLimit = 0.08; -- snake speed
        if timer >= timerLimit then
            timer = timer - timerLimit;

            if #directionQueue1 > 1 then
                table.remove(directionQueue1, 1);
            end
            if #directionQueue2 > 1 then
                table.remove(directionQueue2, 1);
            end

            local nextXPosition1 = snake1Segments[1].x;
            local nextYPosition1 = snake1Segments[1].y;
            local nextXPosition2 = snake2Segments[1].x;
            local nextYPosition2 = snake2Segments[1].y;

            if directionQueue1[1] == 'right' then
                nextXPosition1 = nextXPosition1 + 1;
                if nextXPosition1 > gridXCount then
                    table.remove(snake1Segments);
                    snakeAlive = false;
                    currentScore1 = 0;
                end
                
            elseif directionQueue1[1] == 'left' then
                nextXPosition1 = nextXPosition1 - 1;
                if nextXPosition1 < 1 then
                    table.remove(snake1Segments);
                    snakeAlive = false;
                    currentScore1 = 0;
                end
                
            elseif directionQueue1[1] == 'down' then
                nextYPosition1 = nextYPosition1 + 1;
                if nextYPosition1 > (gridYCount + 3) then
                    table.remove(snake1Segments);
                    snakeAlive = false;
                    currentScore1 = 0;
                end
                
            elseif directionQueue1[1] == 'up' then
                nextYPosition1 = nextYPosition1 - 1;
                if nextYPosition1 < 4 then
                    table.remove(snake1Segments);
                    snakeAlive = false;
                    currentScore1 = 0;
                end
            end

            if directionQueue2[1] == 'right' then
                nextXPosition2 = nextXPosition2 + 1;
                if nextXPosition2 > gridXCount then
                    table.remove(snake2Segments);
                    snakeAlive = false;
                    currentScore2 = 0;
                end
                
            elseif directionQueue2[1] == 'left' then
                nextXPosition2 = nextXPosition2 - 1;
                if nextXPosition2 < 1 then
                    table.remove(snake2Segments);
                    snakeAlive = false;
                    currentScore2 = 0;
                end
                
            elseif directionQueue2[1] == 'down' then
                nextYPosition2 = nextYPosition2 + 1;
                if nextYPosition2 > (gridYCount + 3) then
                    table.remove(snake2Segments);
                    snakeAlive = false;
                    currentScore2 = 0;
                end
                
            elseif directionQueue2[1] == 'up' then
                nextYPosition2 = nextYPosition2 - 1;
                if nextYPosition2 < 4 then
                    table.remove(snake2Segments);
                    snakeAlive = false;
                    currentScore2 = 0;
                end
            end

            local canMove1 = true;
            local canMove2 = true;

            -- for segmentIndex, segment in ipairs(snake1Segments) do
            --     if segmentIndex ~= #snake1Segments
            --     and nextXPosition1 == segment.x 
            --     and nextYPosition1 == segment.y then -- this stops the player going back on itself
            --         canMove1 = false;
            --     end
            -- end
            -- for segmentIndex, segment in ipairs(snake2Segments) do
            --     if segmentIndex ~= #snake2Segments
            --     and nextXPosition2 == segment.x 
            --     and nextYPosition2 == segment.y then -- this stops the player going back on itself
            --         canMove2 = false;
            --     end
            -- end

            for segmentIndex1, segment1 in ipairs(snake1Segments) do
                for segmentIndex2, segment2 in ipairs(snake2Segments) do 
                    if segmentIndex2 ~= #snake2Segments
                    and ((nextXPosition2 == segment2.x 
                    and nextYPosition2 == segment2.y) 
                    or (nextXPosition2 == segment1.x 
                    and nextYPosition2 == segment1.y)
                    or (nextXPosition1 == segment2.x
                    and nextYPosition1 == segment2.y)) then -- this stops the player going back on itself
                        canMove2 = false;
                    end
                end
                if segmentIndex ~= #snake1Segments
                and nextXPosition1 == segment1.x 
                and nextYPosition1 == segment1.y then -- this stops the player going back on itself
                    canMove1 = false;
                end
            end

            if canMove1 then
                table.insert(snake1Segments, 1, {x = nextXPosition1, y = nextYPosition1})

                if snake1Segments[1].x == foodPosition.x
                and snake1Segments[1].y == foodPosition.y then
                    moveFood();
                    if foodColor == 1 then
                        currentScore1 = currentScore1 + 1;
                    elseif foodColor == 2 then
                        currentScore1 = currentScore1 + 2;
                    elseif foodColor == 3 then
                        currentScore1 = currentScore1 + 3;
                    end
                else
                    table.remove(snake1Segments);
                end
            else
                snakeAlive = false;
                currentScore1 = 0;
            end
            if canMove2 then
                table.insert(snake2Segments, 1, {x = nextXPosition2, y = nextYPosition2})

                if snake2Segments[1].x == foodPosition.x
                and snake2Segments[1].y == foodPosition.y then
                    moveFood();
                    if foodColor == 1 then
                        currentScore2 = currentScore2 + 1;
                    elseif foodColor == 2 then
                        currentScore2 = currentScore2 + 2;
                    elseif foodColor == 3 then
                        currentScore2 = currentScore2 + 3;
                    end
                else
                    table.remove(snake2Segments);
                end
            else
                snakeAlive = false;
                currentScore2 = 0;
            end
        end

    elseif timer >= 1.5 then
        if currentScore1 > bestScore1 then
            bestScore1 = currentScore1
        end
        if currentScore2 > bestScore2 then
            bestScore2 = currentScore2
        end
        reset(); -- when the snake dies, the timer stops. if the timer has stopped for 1.5 seconds, restart the game.
    end
end

function createGameWindow()
  love.graphics.setColor(28/255, 28/255, 28/255);
  love.graphics.rectangle('fill', 0, 45, gridXCount * cellSize , (gridYCount * cellSize)); -- The Game Window
  end

function love.draw()
    local cellSize = 15;

    createGameWindow();

    local function drawCell(x, y)
        love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellSize - 1, cellSize - 1); -- draw entity function
    end

    for segmentIndex, segment in ipairs(snake1Segments) do
        if snakeAlive then
            love.graphics.setColor(173/255, 255/255, 47/255); -- snake colour
        else
            love.graphics.setColor(70/255, 70/255, 70/255); -- dead snake colour
        end
        drawCell(segment.x, segment.y); -- draw snake
    end

    for segmentIndex, segment in ipairs(snake2Segments) do
        if snakeAlive then
            love.graphics.setColor(255/255, 173/255, 47/255);
        else
            love.graphics.setColor(70/255, 70/255, 70/255);
        end
        drawCell(segment.x, segment.y);
    end

    if foodColor == 1 then
        love.graphics.setColor(1, 0, 0); -- food colour
    elseif foodColor == 2 then
        love.graphics.setColor(0, 1, 0);
    elseif foodColor == 3 then
        love.graphics.setColor(0, 0, 1);
    end
    drawCell(foodPosition.x, foodPosition.y);
    
    drawGUI();
end

function love.keypressed(key)
    if (key == "d")
    and directionQueue1[#directionQueue1] ~= 'right'
    and directionQueue1[#directionQueue1] ~= 'left' then
        table.insert(directionQueue1, 'right')

    elseif (key == "a")
    and directionQueue1[#directionQueue1] ~= 'left'
    and directionQueue1[#directionQueue1] ~= 'right' then
        table.insert(directionQueue1, 'left')

    elseif (key == "w")
    and directionQueue1[#directionQueue1] ~= 'up'
    and directionQueue1[#directionQueue1] ~= 'down' then
        table.insert(directionQueue1, 'up')

    elseif (key == "s")
    and directionQueue1[#directionQueue1] ~= 'down'
    and directionQueue1[#directionQueue1] ~= 'up' then
        table.insert(directionQueue1, 'down')

    elseif (key == "right")
    and directionQueue2[#directionQueue2] ~= 'right'
    and directionQueue2[#directionQueue2] ~= 'left' then
        table.insert(directionQueue2, 'right')

    elseif (key == "left")
    and directionQueue2[#directionQueue2] ~= 'left'
    and directionQueue2[#directionQueue2] ~= 'right' then
        table.insert(directionQueue2, 'left')

    elseif (key == "up")
    and directionQueue2[#directionQueue2] ~= 'up'
    and directionQueue2[#directionQueue2] ~= 'down' then
        table.insert(directionQueue2, 'up')

    elseif (key == "down")
    and directionQueue2[#directionQueue2] ~= 'down'
    and directionQueue2[#directionQueue2] ~= 'up' then
        table.insert(directionQueue2, 'down')
    end
end

function drawGUI()
  
  love.graphics.setColor(1, 1, 1);
  font = love.graphics.newFont(28);
  love.graphics.setFont(font);
  love.graphics.print("- SNAKE -", 235, 5);
  
  font = love.graphics.newFont(15); -- font size+
  love.graphics.setFont(font);
  
  love.graphics.print("P1: " .. tostring(currentScore1), 10, 425);
  love.graphics.print("P2: " .. tostring(currentScore2), 110, 425);
  love.graphics.print("Timer: " .. tostring(math.floor(gameTimer)), 210, 425);
  love.graphics.print("P1 Best: " .. tostring(bestScore1), 320, 425);
  love.graphics.print("P2 Best: " .. tostring(bestScore2), 450, 425);
  
  end
