board22=zeros(4,4,4);
allmoves1=[];
allmoves2=[];
for turn=1:sum(board22(:)==0)
	if rem(turn, 2) == 0
		disp('------------one---------');
		moveVec=playTTTT(board22,1);
		allmoves1=cat(2,allmoves1,moveVec);
		board22(moveVec(1),moveVec(2),moveVec(3)) = 1;
	else
		disp('------------two---------');
		moveVec=playTTTT(board22,2);
		allmoves2=cat(2,allmoves2,moveVec);
		board22(moveVec(1),moveVec(2),moveVec(3)) = 2;
	end
end