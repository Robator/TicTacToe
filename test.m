board=zeros(4,4,4);
for turn=1:64
	if rem(turn, 2) == 0
		moveVec=playTTTT(board,1);
		board(moveVec(1),moveVec(2),moveVec(3)) = 1;
	else
		moveVec=playTTTT(board,2);
		board(moveVec(1),moveVec(2),moveVec(3)) = 2;
	end
end