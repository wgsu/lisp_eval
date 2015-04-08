%% @author Wei
%% @doc @todo Add description to ereval.

-module(ereval).

-export([add/2, fact/1,fib/1, car/1,cdr/1,lispatom/2,lookup/2,lisplist/2,lispeval/2,addvar/2,evalapply/3,lispif/2]).

add(X,Y)->
	X+Y.
fact(N)when N>0 -> 
 N*fact(N-1);
fact(0)->1.

fib(N)when N>1 -> fib(N-2)+fib(N-1);
fib(0)->0;
fib(1)->1.
car([H|_T]) -> H. 
cdr([_H|T]) -> T. 
%%end of hw9

lispeval(ExprM,Env)->
  if 
		(is_number(ExprM)) or (is_atom(ExprM))->lispatom(ExprM,Env);
		true-> lisplist(ExprM,Env)
			end.

lisplist(ExprL,Env)->
	case (car(ExprL)== quote)of
	true-> cdr(ExprL);
	false->case (car(ExprL)== iff)of
		true->lispif(cdr(ExprL),Env);
		false->case(is_function(lookup(car(ExprL),Env)))of 
		true ->apply(lookup(car(ExprL),Env),addvar(cdr(ExprL),Env));
		false -> evalapply(lookup(car(ExprL),Env), addvar(cdr(ExprL),Env),Env)
		end 
end
end.

lispif([Iffs,Right,Wrong],Env)->
case(lispeval(Iffs,Env))of 
	
	true->lispeval(Right,Env);
	
	false->lispeval(Wrong,Env)
end.
evalapply([lambda, Parms, Body],Evaledargs,Env)->
	lispeval(
		Body,
		lists:append(lists:zip(Parms, Evaledargs), Env)
	).

addvar(Var,Env) ->
	%%- io:write(addvar), io:write(Var),
	if 
		(Var==[])->[];
		true->  [lispeval(car(Var),Env)|addvar(cdr(Var),Env)]
	end.
	
lispatom(Expr,Env) ->
	 if 
				 (is_number(Expr)) -> Expr; 
				(is_atom (Expr)) ->  lookup(Expr,Env)
			 
				end .



lookup(Key,[{Ele,Val}|Env])-> 
	if
		(Ele==Key)->Val;
		(Env==[])->"var not found in env";
	 	true->lookup(Key,Env)
							  end.   
%%cd("C://Users//Wei//Documents//homework//SU//ErlangEval//src//").
%%ereval:lispeval(y, [{x,22},{y,25}, {equal, fun erlang:'=='/2},{plus,fun erlang:'+'/2},{minus,fun erlang:'-'/2},{times,fun erlang:'*'/2},{equal, fun erlang:'=='/2} ]).
%%%ereval:lispeval([times,x,[plus,x,y]], [{x,22},{y,25}, {equal, fun erlang:'=='/2},{plus,fun erlang:'+'/2},{minus,fun erlang:'-'/2},{times,fun erlang:'*'/2},{equal, fun erlang:'=='/2},{dbl,[lambda,[x],[plus,x,x]]}]).
%%ereval:lispeval([iff,[equal,x,60],[times, 50 ,x],[plus ,4546 ,y]],[{x,22},{y,25}, {equal, fun erlang:'=='/2},{plus,fun erlang:'+'/2},{minus,fun erlang:'-'/2},{times,fun erlang:'*'/2},{equal, fun erlang:'=='/2},{dbl,[lambda,[x],[plus,x,x]]}]).
