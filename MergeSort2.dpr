program MergeSort2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  A:array of integer;

procedure InitArray(ar:array of integer);
var
  i:integer;

begin
  SetLength(A,Length(ar));
  for i:=0 to pred(Length(ar)) do
    A[i]:=ar[i];
end;

procedure MergeSort(var Arr:array of integer);
var
  tmp : array of integer; //Временный буфер

  //Слияние
  procedure merge(L, Spl, R : Integer);
  var
    i, j, k : Integer;
  begin
    i := L;
    j := Spl + 1;
    k := 0;
    //Выбираем меньший из первых и добавляем в tmp
    while (i <= Spl) and (j <=R) do
    begin
      if (Arr[i] > Arr[j]) then
      begin
        tmp[k] := Arr[j];
        Inc(j);
      end
      else
      begin
        tmp[k] := Arr[i];
        Inc(i);
      end;
      Inc(k);
    end;
    //Просто дописываем в tmp оставшиеся эл-ты
    if i <= Spl then      //Если первая часть не пуста
      for j := i to Spl do
      begin
        tmp[k] := Arr[j];
        Inc(k);
      end
    else                  //Если вторая часть не пуста
      for i := j to R do
      begin
        tmp[k] := Arr[i];
        Inc(k);
      end;
    //Перемещаем из tmp в arr
    Move(tmp[0], Arr[L], k*SizeOf(integer));
  end;

  //Сортировка
  procedure sort(L, R : Integer);
  var
    splitter : Integer;

  begin
    //Массив из 1-го эл-та упорядочен по определению
    if L >= R then Exit;
    splitter := (L + R) div 2;  //Делим массив пополам
    sort(L, splitter);          //Сортируем каждую
    sort(splitter + 1, R);      //часть по отдельности
    merge(L, splitter, R);      //Производим слияние
  end;

  //Основная часть процедуры сортировки
begin
  SetLength(tmp, Length(Arr));
  sort(0, Length(Arr) - 1);
  SetLength(tmp, 0);
end;

// --- ---

procedure ShowArray(var ar:array of integer);
var
  i:integer;
begin
  for i:=0 to Length(ar)-1 do
    writeln(i,': ',ar[i]);
end;

procedure ShowArrayInline(var ar:array of integer);
var
  i:integer;
begin
  for i:=0 to Length(ar)-1 do
    write(ar[i],' ');
  writeln;
end;

begin
  InitArray([5,2,4,6,1,3,2,6]);
  writeln('Before:'); ShowArrayInline(A);
  MergeSort(A);
  writeln('After:'); ShowArrayInline(A);
end.
