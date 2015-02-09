close all; clear all; clc; 

% Number of criteria = number of utility functions
c = 3;  

% min and max values
amin = [-1 0 1]; 
amax = [2 1.5 3]; 

% Examples: a1 >= a2, et a2 >= a3
a1 = [-0.1 0.5   3]; 
a2 = [0    1.5   2]; 
a3 = [-1   1     3]; 

 a1 = [2 1.5 3]; 
 a2 = [0  1  2]; 
 a3 = [-1 0 1]; 

% a1 = [1  1  1]; 
% a2 = [1/2  1/2  1/2]; 
% a3 = [0  0  0]; 

% a1 = rand(1,3)
% a2 = rand(1,3)
% a3 = rand(1,3)
% amin = [0 0 0]; 
% amax = [1 1 1]; 

A = [a1; a2; a3]

% Degree of utility functions
d = 4; 
% In the SDP
n = ceil(d/2+1);

% Create and solve the model for infinity norm
cvx_begin
    variable a(d+1,c) % Each column represent an utility function
    variable Q1(n,n) symmetric
    variable Q2(n,n) symmetric
    variable Q3(n,n) symmetric
    variable obj(1) 
    % maximize difference between u(a1) and u(a2), and u(a2) and u(a3)
    % u(a1) = u1(a11) + u2(a12) + u3(a13)
    %       = a1(1).^(0:d)*a(:,1) + a1(2).^(0:d)*a(:,2) + a1(3).^(0:d)*a(:,3)
    maximize(  obj  ) 
    subject to

%        obj <= (uj(1,1) + uj(1,2) + uj(1,3)) - (uj(2,1) + uj(2,2) + uj(2,3));
%        obj <= (uj(2,1) + uj(2,2) + uj(2,3)) - (uj(3,1) + uj(3,2) + uj(3,3));
%        obj <= (uj(1,1) + uj(1,2) + uj(1,3)) - (uj(3,1) + uj(3,2) + uj(3,3));

%	tmp = (A(1,1).^(0:d)*a(:,1) + A(1,2).^(0:d)*a(:,2) + A(1,3).^(0:d)*a(:,3)) - ...
%		(A(2,1).^(0:d)*a(:,1) + A(2,2).^(0:d)*a(:,2) + A(2,3).^(0:d)*a(:,3));
	tmp = 0
	tmp = tmp + A(1,1).^(0:d)*a(:,1)
	tmp = tmp + A(1,2).^(0:d)*a(:,2)
	tmp = tmp + A(1,3).^(0:d)*a(:,3)
	tmp = tmp - A(2,1).^(0:d)*a(:,1)
	tmp = tmp - A(2,2).^(0:d)*a(:,2)
	tmp = tmp - A(2,3).^(0:d)*a(:,3)

	obj <= tmp;

	tmp = (A(2,1).^(0:d)*a(:,1) + A(2,2).^(0:d)*a(:,2) + A(2,3).^(0:d)*a(:,3)) - ... 
	        (A(3,1).^(0:d)*a(:,1) + A(3,2).^(0:d)*a(:,2) + A(3,3).^(0:d)*a(:,3)); 
	obj <= tmp;

	tmp = (A(1,1).^(0:d)*a(:,1) + A(1,2).^(0:d)*a(:,2) + A(1,3).^(0:d)*a(:,3)) - ...
	        (A(3,1).^(0:d)*a(:,1) + A(3,2).^(0:d)*a(:,2) + A(3,3).^(0:d)*a(:,3)); 
	obj <= tmp;

%	tmp = (A(1,1).^(0:d)*a(:,1) + A(1,2).^(0:d)*a(:,2) + A(1,3).^(0:d)*a(:,3)) - ...
%		(A(2,1).^(0:d)*a(:,1) + A(2,2).^(0:d)*a(:,2) + A(2,3).^(0:d)*a(:,3)); 
%	obj <= tmp;
%
%	tmp = (A(2,1).^(0:d)*a(:,1) + A(2,2).^(0:d)*a(:,2) + A(2,3).^(0:d)*a(:,3)) - ... 
%		(A(3,1).^(0:d)*a(:,1) + A(3,2).^(0:d)*a(:,2) + A(3,3).^(0:d)*a(:,3)); 
%
%	obj <= tmp;
%	tmp = (A(1,1).^(0:d)*a(:,1) + A(1,2).^(0:d)*a(:,2) + A(1,3).^(0:d)*a(:,3)) - ...
%		(A(3,1).^(0:d)*a(:,1) + A(3,2).^(0:d)*a(:,2) + A(3,3).^(0:d)*a(:,3)); 
%	obj <= tmp;


%        obj <= (A(1,1).^(0:d)*a(:,1) + A(1,2).^(0:d)*a(:,2) + A(1,3).^(0:d)*a(:,3)) - ...
%                (A(2,1).^(0:d)*a(:,1) + A(2,2).^(0:d)*a(:,2) + A(2,3).^(0:d)*a(:,3)); 
%        obj <= (A(2,1).^(0:d)*a(:,1) + A(2,2).^(0:d)*a(:,2) + A(2,3).^(0:d)*a(:,3)) - ... 
%                (A(3,1).^(0:d)*a(:,1) + A(3,2).^(0:d)*a(:,2) + A(3,3).^(0:d)*a(:,3)); 
%        obj <= (A(1,1).^(0:d)*a(:,1) + A(1,2).^(0:d)*a(:,2) + A(1,3).^(0:d)*a(:,3)) - ...
%                (A(3,1).^(0:d)*a(:,1) + A(3,2).^(0:d)*a(:,2) + A(3,3).^(0:d)*a(:,3)); 


%        obj <= (a1(1).^(0:d)*a(:,1) + a1(2).^(0:d)*a(:,2) + a1(3).^(0:d)*a(:,3)) - ...
%                (a2(1).^(0:d)*a(:,1) + a2(2).^(0:d)*a(:,2) + a2(3).^(0:d)*a(:,3)); 
%        obj <= (a2(1).^(0:d)*a(:,1) + a2(2).^(0:d)*a(:,2) + a2(3).^(0:d)*a(:,3)) - ... 
%                (a3(1).^(0:d)*a(:,1) + a3(2).^(0:d)*a(:,2) + a3(3).^(0:d)*a(:,3)); 
%        obj <= (a1(1).^(0:d)*a(:,1) + a1(2).^(0:d)*a(:,2) + a1(3).^(0:d)*a(:,3)) - ...
%                (a3(1).^(0:d)*a(:,1) + a3(2).^(0:d)*a(:,2) + a3(3).^(0:d)*a(:,3)); 
            
        Q1 == semidefinite(n); Q2 == semidefinite(n); Q3 == semidefinite(n); 
        
	k = 1 - n
	for i = 2:2*n
		if i > length(a(:,1))
			sum(diag(rot90(Q1), k)) == 0;
			sum(diag(rot90(Q2), k)) == 0;
			sum(diag(rot90(Q3), k)) == 0;
		else
			sum(diag(rot90(Q1), k)) == (i - 1) * a(i, 1);
			sum(diag(rot90(Q2), k)) == (i - 1) * a(i, 2);
			sum(diag(rot90(Q3), k)) == (i - 1) * a(i, 3);
		end

		k = k + 1
	end

%        deg = 2; 
%        for k = n-1 : -1 : -n+1 
%            % Constraint on sum of each off diagonal entries of Q
%            A = diag(ones( min(n-k,n+k),1),k); 
%            A = A(:,end:-1:1); 
%            %sum(sum(A.*Q)) == d*a(d); 
%            indA = find(A>0); 
%
%            if deg > length(a(:,1))
%                sum(Q1(indA)) == 0;
%                sum(Q2(indA)) == 0;
%                sum(Q3(indA)) == 0;
%            else
%                sum(Q1(indA)) == (deg-1)*a(deg,1);
%                sum(Q2(indA)) == (deg-1)*a(deg,2);
%                sum(Q3(indA)) == (deg-1)*a(deg,3);
%            end
%
%            deg = deg+1;
%        end

%        deg = 2; 
%        for k = n-1 : -1 : -n+1 
%            % Constraint on sum of each off diagonal entries of Q
%            A = diag(ones( min(n-k,n+k),1),k); 
%            A = A(:,end:-1:1); 
%            %sum(sum(A.*Q)) == d*a(d); 
%            indA = find(A>0); 
%            
%            if deg > length(a(:,1))
%                Q1(indA)'*ones(length(indA),1) == 0; 
%                Q2(indA)'*ones(length(indA),1) == 0;  
%                Q3(indA)'*ones(length(indA),1) == 0; 
%            else                
%                Q1(indA)'*ones(length(indA),1) == (deg-1)*a(deg,1); 
%                Q2(indA)'*ones(length(indA),1) == (deg-1)*a(deg,2); 
%                Q3(indA)'*ones(length(indA),1) == (deg-1)*a(deg,3); 
%            end
%
%            deg = deg+1; 
%        end 
        
        % u(amax) = 1
        (amax(1).^(0:d)*a(:,1) + amax(2).^(0:d)*a(:,2) + amax(3).^(0:d)*a(:,3)) == 1; 
        
        % u_i(amin_i) = 0
        amin(1).^(0:d)*a(:,1) == 0; 
        amin(2).^(0:d)*a(:,2) == 0; 
        amin(3).^(0:d)*a(:,3) == 0; 

cvx_end

fliplr(a')

% Display results
colors{1} = 'b' ; 
colors{2} = 'r' ; 
colors{3} = 'k' ; 

xmin = min(amin); 
xmax = max(amax); 
x = xmin-.1:0.01:xmax+.1; 
fmax = 0; fmin = 0; 
for cr = 1 : 3
    f = 0;
    for i = 0 : d
        f = f + a(i+1,cr)*x.^(i);
    end
    fmax = max(fmax,max(f)); fmin = min(fmin,min(f)); 
    plot(x, f, colors{cr}); hold on; 
end

legend('utility 1', 'utility 2', 'utility 3')

for cr = 1 : 3
    plot([amin(cr) amin(cr)], [fmin fmax], colors{cr}); 
    plot([amax(cr) amax(cr)], [fmin fmax], colors{cr}); 
end


disp('Utilités: ')
U = [(a1(1).^(0:d)*a(:,1) + a1(2).^(0:d)*a(:,2) + a1(3).^(0:d)*a(:,3)) ; 
(a2(1).^(0:d)*a(:,1) + a2(2).^(0:d)*a(:,2) + a2(3).^(0:d)*a(:,3)); 
(a3(1).^(0:d)*a(:,1) + a3(2).^(0:d)*a(:,2) + a3(3).^(0:d)*a(:,3)) ]

disp('U(1) - U(1) and U(2) - U(3): ')
[U(1) - U(2), U(2) - U(3)]         
