function tictactoe2()
global summa
summa = 0;
%     board = [0,0,0,0,0,0,0,0,0];
	board = zeros(1, 64);
    player=1;
    for turn=1:64
		%if there is no winner or not a draw
        if win(board) == 0		
            if rem(turn+player, 2) == 0	%reminder
				if turn==1
					%computer`s first move to 0 cell
					board(1)=1;		
				else
					board = computerMove(board);
				end
			else 
				draw(board);
				board = playerMove(board);
			end
		end
	end
    write_winner(board);
end

function write_winner(board)
switch win(board) 
        case 0
			draw(board);
            disp('A draw. How droll.\n');
			
        case 1
            draw(board);
            disp('You lose.\n');
        case -1
			draw(board);
            disp('You win. Inconceivable!\n');
    end
end

function c = gridChar(i) 
    switch i 
        case -1 
            c='X';
        case 0
            c=' ';
        case 1
            c='O';
    end
end

function win = win(board) %win combinations
	%determines if a player has won, returns 0 otherwise.
	
     wins1 = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16;
        1 5 9 13; 2 6 10 14; 3 7 11 15; 4 8 12 16;
        1 6 11 16; 4 7 10 13];%on plane 1
    wins2 = wins1+16;
    wins3 = wins2+16;%on plane 3
    wins4 = wins3+16;%40 on plane 4
    wins5 = [1 17 33 49; 2 18 34 50; 3 19 35 51; 4 20 36 52; 1 18 35 52; 4 19 34 49];%vertical plane 1
    wins6 = wins5+4;
    wins7 = wins6+4;%vertical plane 3
    wins8 = wins7+4;%24
    wins9 = [1 22 43 64; 4 23 42 61; 13 26 39 52; 16 27 38 49];%diagonals
	wins = cat(1, wins1, wins2, wins3, wins4, wins5, wins6, wins7, wins8, wins9);%two-dimensional big array
    for i=1:68
        if board(wins(i,1)) ~= 0 && ...
           board(wins(i,1)) == board(wins(i,2)) && ... 
           board(wins(i,1)) == board(wins(i,3)) && ...
		   board(wins(i,1)) == board(wins(i,4))
            win = board(wins(i,1));
            return
        end
    end
    win = 0;
end

function draw( b)
	for i=1:16:48
        fprintf(' %c | %c | %c | %c\n',gridChar(b(i)),gridChar(b(i+1)),gridChar(b(i+2)),gridChar(b(i+3)));
        disp('---+---+----+-----\n');
        fprintf(' %c | %c | %c | %c\n',gridChar(b(i+4)),gridChar(b(i+5)),gridChar(b(i+6)),gridChar(b(i+7)));
        disp('---+---+----+-----\n');
        fprintf(' %c | %c | %c | %c\n',gridChar(b(i+8)),gridChar(b(i+9)),gridChar(b(i+10)),gridChar(b(i+11)));
		disp('---+---+----+-----\n');
        fprintf(' %c | %c | %c | %c\n',gridChar(b(i+12)),gridChar(b(i+13)),gridChar(b(i+14)),gridChar(b(i+15)));
        disp('\n')
	end
end

function a = minimax(board, player) 
	global summa
	%How is the position like for player (their turn) on board?
    winner = win(board);
    if(winner ~= 0) 
        a = winner*player;
		return
    end

    move = -1;
    score = -2;%Losing moves are preferred to no move
    for i=1:5%For all moves,
        summa=summa+1;
        if(board(i) == 0)%if empty
            board(i) = player;%try the move
            
            thisScore = -minimax(board, player*(-1));
            if(thisScore > score) 
                score = thisScore;
                move = i;
            end
            board(i) = 0;%Reset board after try
        end
    end
    if(move == -1) %the bottom of the tree returns 0
        a = 0;
        return
    end
    a = score;
end

function board = computerMove(board) 
    move = -1;
    score = -2;
    for i=1:64
        if(board(i) == 0) 
            board(i) = 1;
            tempScore = -minimax(board, -1);
            board(i) = 0;
            if(tempScore > score) 
                score = tempScore;
                move = i;
            end
        end
	end
	%make a move that has the maximum score
    board(move) = 1;
end

function board = playerMove(board) 
    move = -1;
    while move >= 64 || move < 0 || board(move) ~= 0
        moveVec = input('\nInput move ([1..4, 1..4, 1..4]): ');
		move = moveVec(1)+(moveVec(2)-1)*4 +(moveVec(3)-1)*16;
		disp(move);
        if(board(move)==0)
            disp(board(move));
            board(move) = -1;
            disp(board(move));
            return;
        else
            disp('cell is full, try again')
            move = -1;
		end
    end
    board(move) = -1;
end

