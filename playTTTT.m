function move = playTTTT(board, player)
%Tictactoe 3D game is based on minimax algorithm with some improvements

	%transform matrix to an array - easier to implement
	board = arrToBoard(board);
	move = -1;%init
    score = -2;
	depth = 2;
	
	%if empty - give random move
	if (sum(board)==0)
	   move = round(rand*63)+1;
	   move = mtoV(move);
	   return;
	end

	%players encoded for minimax
    if player==1 
        plr = -1;
    elseif player==2
        plr = 1;
	else
		disp('Wrong player');
		return		
	end
	
	%make minimax for all cells
    for i=1:64
		%for empty cells try
        if(board(i) == 0) 
			%try the first empty cell
            board(i) = player;
            if player==1
            tempScore = -minimax(board, depth, plr, 'X');
            else
                tempScore = -minimax(board, depth, plr, 'O');
            end
            board(i) = 0;%reset cell
            if(tempScore > score) 
                score = tempScore;
                move = i;
			end
			if score == 1 %cant play better
				break
            end
			
		end
		
    end
    if (score == 0) 
        while(true)
        move = round(63*rand)+1;
        if (board(move)==0)
            move = mtoV(move);
           return; 
        end
            
        end
    else
    move = mtoV(move);
	end
	return
	%make a move that has the maximum score
    %board(move) = plr;
end

function a = minimax(board, depth, player, xo) %crouch
    if (player == -1)%transorm for filling board
        plr = 1;
    else
        plr = 2;
    end
	%How is the position like for player (their turn) on board?
    winner = win(board);
    if(winner ~= 0) %someone has won
        if (winner == 1)
            wnr = -1;
        else
            wnr = 1;
        end
        a = wnr*player;
		return
	end
	if depth == 0%depth limit exceeded
		a=0;
		return
	end
    move = -1;
    score = -2;%Losing moves are preferred to no move
    for i=1:64%For all moves,
        if(board(i) == 0)%if empty
            board(i) = plr;%try the move
            if xo == 'X' %if initial player is X
			thisScore = -Xminimax(board, depth-1, player*(-1), xo);
			
			if score == 1 && player==-1 || score == -1 && player==1%cant play better
				break
			end

            if(thisScore > score) %found better solution
                score = thisScore;
                move = i;
            end
            
            else %if initial player is O
            thisScore = -minimax(board, depth-1, player*(-1), xo);
			
			if score == 1 && player==1 || score == -1 && player==-1%cant play better
				break
			end

            if(thisScore < score) %found better solution
                score = thisScore;
                move = i;
            end
            
            end
            board(i) = 0;%Reset board after try

        end
    end
    if move == -1 %all cells are full
        a = 0;
        return
	end
    a = score;
end



function res = mtoV(mv) 
    k = ceil((mv)/16);
    mv = mv - 16*(k-1);
    j = ceil(mv/4);
    mv = mv - 4*(j-1);
    i = mv;
    res = [j i k]';
end

function boardArr = arrToBoard(board)
    boardArr=[];
    for i=1:4
        for j=1:4
            boardArr = cat(2, boardArr, board(j, :, i));
        end
    end
end