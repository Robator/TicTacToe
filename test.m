function test()	
board22=zeros(4,4,4);
	allmoves1=[];
	allmoves2=[];
	for turn=1:sum(board22(:)==0)
		if rem(turn, 2) == 0
	% 		disp('------------one---------');
			if rem(turn,5)==0
				fprintf('!');
			end
			moveVec=playTTTT(board22,1);
			if write_winner(board22)
				break
			end
			allmoves1=cat(2,allmoves1,moveVec);
			board22(moveVec(1),moveVec(2),moveVec(3)) = 1;
		else
	% 		disp('------------two---------');
			if rem(turn,5)==0
				fprintf('!');
			end
			moveVec=playTTTT(board22,2);
			if write_winner(board22)
				break
			end
			allmoves2=cat(2,allmoves2,moveVec);
			board22(moveVec(1),moveVec(2),moveVec(3)) = 2;
		end
	end
end

function [winner] = write_winner(board)
switch win(board) 
        case 0
% 			draw(board);
			winner=0;
			if sum(board(:)==0)==0
				winner=1;
				disp('A draw. How droll.\n');
			end
        case 1
			winner=1;
%             draw(board);
            disp('X win.\n');
        case 2
			winner=2;
% 			draw(board);
            disp('O win. Inconceivable!\n');
    end
end

function winner = win(board) %win combinations
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
            winner = board(wins(i,1));
            return
        end
    end
    winner = 0;
end
