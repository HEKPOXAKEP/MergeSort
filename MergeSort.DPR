{$APPTYPE CONSOLE}
program MergeSort;

uses
  SysUtils,
  Math,
  RxStrUtils;

const
  IPID = 'MergeSort';
  PID = 'Сортировка (массива) слиянием';
  VID = '0.01.01/a0526';
  CID = 'Copyright 2023 LAGODROM Solutions Ltd.';
  crlf = #13#10;

type
  {
    Динамический массив, в котором нумерация
    элементов начинается с 1, а не с 0
  }
  TArr = class(TObject)
  private
    FA:array of integer;
  protected
    function _Get(i:integer):integer;
    procedure _Set(i:integer; const v:integer);
    function GetLength:integer;
    procedure SetLength(i:integer);
    function GetHigh:integer;
    function GetLow:integer;
    procedure Sort(p,r:integer);
    procedure Merge(p,q,r:integer);
  public
    constructor Create(const len:integer);
    //destructor Destroy; override;
    procedure Show;
    procedure ShowInline;
    procedure InitValues(v:array of integer);
    // ---
    procedure DoSort(p,r:integer);  // инициализация и сортировка
    // ---
    property Value[i:integer]:integer read _Get write _Set; default;
    property Length:integer read GetLength write SetLength;
    property High:integer read GetHigh;
    property Low:integer read GetLow;
  end;

var
  Arr,
  FB:TArr;

procedure wr(const s:string);
begin
  write(StrToOem(s));
end;

procedure wrln(const s:string);
begin
  writeln(StrToOem(s));
end;

{ --- TArr class --- }

constructor TArr.Create(const len:integer);
begin
  inherited Create;

  if len >0 then
    System.SetLength(FA,len);
end;

{destructor TArr.Destroy;
begin
  inherited Destroy;
  System.SetLength(FA,0);
end;}

function TArr._Get(i:integer):integer;
begin
  Result:=FA[i-1];
end;

procedure TArr._Set(i:integer; const v:integer);
begin
  FA[i-1]:=v;
end;

function TArr.GetLength: integer;
begin
  Result:=System.Length(FA);
end;

procedure TArr.SetLength(i: integer);
begin
  System.SetLength(FA,i);
end;

function TArr.GetHigh: integer;
begin
  Result:=System.High(FA)+1;
end;

function TArr.GetLow: integer;
begin
  Result:=System.Low(FA)+1;
end;

procedure TArr.InitValues(v: array of integer);
var
  i:integer;

begin
  Length:=System.Length(v);
  for i:=System.Low(v) to System.High(v) do
    FA[i]:=v[i];
end;

procedure TArr.Show;
var
  i:integer;

begin
  for i:=Low to High do
    writeln(i,': ',Self[i]);
end;

procedure TArr.ShowInline;
var
  i:integer;

begin
  for i:=Low to High do
    write(Self[i],' ');
  writeln;
end;

procedure TArr.DoSort(p,r:integer);
begin
  FB:=TArr.Create(Self.Length);
  Sort(p,r);
  FB.Destroy;
end;

procedure TArr.Sort(p,r:integer);
var
  q:integer;

begin
  if p <r then begin
    q:=(p+r) div 2;

    Sort(p,q);
    Sort(q+1,r);
    Merge(p,q,r);
  end;
end;

procedure TArr.Merge(p, q, R : Integer);
var
  i, j, k : Integer;

begin
  i := p;
  j := q + 1;
  k := 1;
  // Выбираем меньший из первых и добавляем в tmp
  while (i <= q) and (j <= R) do begin
    if (Self[i] > Self[j]) then begin
      FB[k]:=Self[j];
      Inc(j);
    end
    else begin
      FB[k]:=Self[i];
      Inc(i);
    end;
    Inc(k);
  end;
  // Просто дописываем в tmp оставшиеся эл-ты
  if i <= q then      // Если первая часть не пуста
    for j:=i to q do begin
      FB[k]:=Self[j];
      Inc(k);
    end
  else                  // Если вторая часть не пуста
    for i:=j to R do begin
      FB[k]:=Self[i];
      Inc(k);
    end;

  //writeln('k=',k);

  // Перемещаем из tmp в arr
  ///Move(tmp[0], Arr[p], k*SizeOf(TItem));
  for i:=0 to k-2 do begin
    //write(p+i,'(',FB[succ(i)],') ');
    Self[p+i]:=FB[succ(i)];
  end;
  //writeln;
end;

// --- Main block ---

begin
  wrln(IPID+': '+PID+crlf+VID+crlf);

  Arr:=TArr.Create(8);

  wrln('Length: '+IntToStr(Arr.Length)+', Low: '+IntToStr(Arr.Low)+
       ', High: '+IntToStr(Arr.High));

  {SetRoundMode(rmDown);
  ShowRounding;}

  Arr.InitValues([5,2,4,6,13,1,3,2,6]);
  wrln('До сортировки:');
  Arr.ShowInline;

  //Sort(Arr,1,Arr.Length);
  Arr.DoSort(1,Arr.Length);
  wrln('После сортировки:');
  Arr.ShowInline;

  Arr.Destroy;
  writeln('Ok. Buy!');
end.
