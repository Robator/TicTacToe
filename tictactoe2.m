function [] = tictactoe2()

    board = zeros(1, 64);
    player=2;
    for turn=1:64
        if win(board) == 0
            if rem(turn+player, 2) == 0
                board = (qStep(board, 1));
            else 
                board = (qStep(board, -1)); 
            end
        end
    end
    switch win(board) 
        case 0
            disp('A draw. How droll.\n');
        case 1
            disp('You lose.\n');
        case -1
            disp('You win. Inconceivable!\n');
    end
end


function [win] = win(board) 
    wins1 = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16;
        1 5 9 13; 2 6 10 14; 3 7 11 15; 4 8 12 16;
        1 6 11 16; 4 7 10 13];
    wins2 = wins1+16;
    wins3 = wins2+16;
    wins4 = wins3+16;%40
    wins5 = [1 17 33 49; 2 18 34 50; 3 19 35 51; 4 20 36 52; 1 18 35 52; 4 19 34 49];
    wins6 = wins5+4;
    wins7 = wins6+4;
    wins8 = wins7+4;%24
    wins9 = [1 22 43 64; 4 23 42 61; 13 26 39 52; 16 27 38 49];
    wins = cat(1, wins1, wins2, wins3, wins4, wins5, wins6, wins7, wins8, wins9);
    win =0;
    
    for i=1:68
        if board(wins(i,1)) ~= 0 && ...
           board(wins(i,1)) == board(wins(i,2)) && ... 
           board(wins(i,1)) == board(wins(i,3)) && ...
           board(wins(i,1)) == board(wins(i,4))
            win = board(wins(i,1));
            break;
        end
    end
end

function [a] = minimax(board, player) 
     winner = win(board);
    if(winner ~= 0) 
        a = winner*player;
        return;
    end

    move = -1;
    score = -2;
    for i=1:64
        if(board(i) == 0)
            board(i) = player;
            thisScore = -minimax(board, player*(-1));
            if(thisScore > score) 
                score = thisScore;
                move = i;
            end
            board(i) = 0;
        end
    end
    if(move == -1) 
        a = 0;
        return;
    end
    a = score;
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

function Q = getQ(board)
 fid = fopen( 'values.txt', 'r');
 sid = fopen( 'states.txt', 'a+');
    
    i =1;
    states = cell(0);
    values = cell(0);
    vline = fgetl(fid);
    sline = fgetl(sid);
    while ischar(vline)
         Qline = (vline);
         Stline = str2num(sline);
         states{i} =Stline;
         values{i} = Qline;
         vline = fgetl(fid);
         sline = fgetl(sid);
         i=i+1;
    end
        value = [];
    if(size(states)==0)
        found = 0;
    else
        found = 1;
    end
    if(found == 1)
        has = 0;
        for iter = 1:size(states)
			state=cell2mat(states(iter,:));
%             state = states(iter,:);
% 			here may be an error
               if(board ==cell2mat(states(iter)))
                    value = values(iter);
                    has =1;
                    break;
               end
        end
        if(has == 0)
            value = zeros(size(board));
            state = board;
        end
    else
        value = zeros(size(board));
        state = board;
	end
	
    for it=1:64
        if not(state(it)==0)
			value=cell2mat(value);
            value(it) = -1000;
        end
    end
    
    Q = value;
    fclose(fid);
    fclose(sid);
end


function board = qStep(board, player)
disp('pc move started');
LR = 0.1;
DF = 0.9;
% value is 64x64
  value = getQ(board);
    
  
  while(true)
    move = softmax(value);
        if(board(move)==0)      
            board(move) = -1;
            break
        else
            disp('cell is full, try again')
        end
   %move = moveVec(1)+(moveVec(2)-1)*4-1 +(moveVec(3)-1)*16-1;
  end
    
    board(move) = player;
    reward = 0;
    if(win(board) == player)
        reward = 1;
    end
    if(win(board) == -player)
        reward = -1;
    end
    value(move,:) = value(move)+LR*(reward + DF*max(getQ(board))) - value(move);
    disp(mtoV(move));
    saveQ(board, value);
end

function s = siqmEl(value, it)
    s = exp(value(it))/sumSigm(value);
end

function sm = sumSigm(value)
sm = 0;
   for i=1:size(value)
       sm = sm + exp(value(i));
   end
end

function mv = softmax(value)
    res = rand;
    mv = 1+round(rand*63);
    for i=1:64
        des = siqmEl(value, i);
        if(res<des)
            mv = i;
            return;
        else
            res = res-des;
        end
    end
    
end

function [] = saveQ(board, value)
 fid = fopen( 'values.txt', 'a+');
 sid = fopen( 'states.txt', 'a+');
    
    i =1;
    states = cell(0);
    values = cell(0);
    vline = fgetl(fid);
    sline = fgetl(sid);
    while ischar(vline)
         Qline = cell2mat(vline);
         Stline = cell2mat(sline);
         states{i} =Qline;
         values{i} = Stline;
         vline = fgetl(fid);
         sline = fgetl(sid);
         i=i+1;
    end
    
    
     if(size(states)==0)
        found = 0;
	 else
        found = 1;
     end
    it = -1;
    if(found == 1)
        has = 0;
        for iter = 1:states.size()
            stateIn = states(iter);
               if(board == stateIn)
                    has =1;
                    it = iter;
                    break;
               end
        end
        if(has == 0)
        fprintf(sid, '%d ', board);
        fprintf(sid, '\n');
        fprintf(fid, '%f ', value);
        fprintf(fid, '\n');
        else
        fid.clear;
        states(it) = state;
        values(it) = value;
            for i=1:states.size()
             fprintf(sid, '%d ', cell2mat(states(it)));
             fprintf(sid, '\n');
             fprintf(fid, '%f ', cell2mat(values(it)));
             fprintf(fid, '\n');
            end
        end
    else
        fprintf(sid, '%d ', board);
        fprintf(sid, '\n');
        fprintf(fid, '%f ', value);
        fprintf(fid, '\n');
    end
    fclose(fid);
    fclose(sid);
end


function res = mtoV(mv) 
    k = ceil((mv)/16);
    mv = mv - 16*(k-1);
    j = ceil(mv/4);
    mv = mv - 4*(j-1);
    i = mv;
    res = [i j k];
end