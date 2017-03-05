board=zeros(4,4,4);
for turn=1:64
	if rem(turn, 2) == 0
		moveVec=playTTTT(board,1);
		move = moveVec(1)+(moveVec(2)-1)*4 +(moveVec(3)-1)*16;
		board(move) = 1;
	else
		moveVec=playTTTT(board,2);
		move = moveVec(1)+(moveVec(2)-1)*4 +(moveVec(3)-1)*16;
		board(move) = 2;
	end
end