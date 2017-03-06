function draw( b)
%draws board
	for i=0:16:49
		for j=0:4:15
        fprintf(' %c | %c | %c | %c\n',gridChar(b(i+j+1)),gridChar(b(i+j+2)),gridChar(b(i+j+3)),gridChar(b(i+j+4)));
		disp('---+---+----+-----\n');
		end
		
		disp('\n')
	end
end
