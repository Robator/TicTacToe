function [] = tictactoe()

    board = zeros(64);
    player=2;
    for turn=1:64
        if win(board) == 0
            if rem(turn+player, 2) == 0
                (qStep(board));
            else 
                (playerMove(board)); 
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
            board(move) = -1;
            return;
        else
            disp('cell is full, try again')
            move = -1;
        end
    end
    board(move) = -1;
end

function Q = getQ(board)
 fid = fopen( 'values.txt');
    tline = fgetl(fid);
    i =1;
    states = cell(0);
    values = cell(0);
    while ischar(tline)
        input = strsplit(tline, '#');
         states{i} =input(1);
         values{i} = input(2);
         tline = fgetl(fid);
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
            state = states(iter,:);
% 			here may be an error
               if(size(setdiff(board, cell2mat([state{:}])))~=[1 1])
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
            value(it) = -1000;
        end
    end
    
    Q = value;
    fclose(fid);
end


function board = qStep(board)
disp('pc move started');
LR = 0.1;
DF = 0.9;
% value is 64x64
  value = getQ(board);
    
    move = softmax(value);
    
   %move = moveVec(1)+(moveVec(2)-1)*4-1 +(moveVec(3)-1)*16-1;
    
    
    board(move) = 1;
    reward = 0;
    if(win(board) == 1)
        reward = 1;
    end
    if(win(board) == -1)
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

function [] = saveQ(state, value)
fid = fopen( 'values.txt');
    tline = fgetl(fid);
    i =1;
     states = cell(0);
    values = cell(0);
    while ischar(tline)
        input = strsplit(tline, '#');
        states{i} =input(1);
        values{i} = input(2);
        tline = fgetl(fid);
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
               if(state == stateIn)
                    has =1;
                    it = iter;
                    break;
               end
        end
        if(has == 0)
             fid.write(state);
        fid.write('#');
        fid.write(value);
        fid.write('\n');
        else
        fid.clear;
        states(it) = state;
            for i=1:states.size()
            fid.write(states(i));
            fid.write('#');
            fid.write(values(i));
            fid.write('\n');
            end
        end
    end
end


function res = mtoV(mv) 
    k = ceil((mv)/16);
    mv = mv - 16*(k-1);
    j = ceil(mv/4);
    mv = mv - 4*(j-1);
    i = mv;
    res = [i j k];
end