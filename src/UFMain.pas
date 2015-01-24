unit UFMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs;

type
  TFMain = class(TForm)
    Image1: TImage;
    BClear: TButton;
    BStart: TButton;
    LI: TLabel;
    LE: TLabel;
    LResult: TLabel;
    BMark: TButton;
    BReset: TButton;
    LMark: TLabel;
    BSave: TButton;
    BLoad: TButton;
    SaveDialog1: TSaveDialog;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure BClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BStartClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure BMarkClick(Sender: TObject);
    procedure BResetClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BSaveClick(Sender: TObject);
    procedure BLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}
var
MD: boolean;
PM: TPenMode;
XS,YS,XO,YO: integer;
AColor: array [1..12] of TColor;

procedure FillRect();
begin
  FMain.Image1.Canvas.Pen.Color:=clBlack;
  FMain.Image1.Canvas.Brush.Color:=clBlack;
  FMain.Image1.Canvas.Rectangle(0,0,FMain.Image1.Width,FMain.Image1.Height);
end;

procedure TFMain.BClearClick(Sender: TObject);
begin
  FillRect;
end;

procedure Mark(i,j,n: LongWord);
begin
  FMain.Image1.Canvas.Pixels[j,i]:=AColor[n];
  FMain.Refresh;
  Sleep(1);
  if FMain.Image1.Canvas.Pixels[j+1,i]=clWhite then
    Mark(i,j+1,n);
  if FMain.Image1.Canvas.Pixels[j-1,i]=clWhite then
    Mark(i,j-1,n);
  if FMain.Image1.Canvas.Pixels[j,i+1]=clWhite then
    Mark(i+1,j,n);
  if FMain.Image1.Canvas.Pixels[j,i-1]=clWhite then
    Mark(i-1,j,n);
end;

procedure TFMain.BLoadClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);

end;

procedure TFMain.BMarkClick(Sender: TObject);
var
p: byte;
i,j: LongWord;
begin
  BResetClick(nil);
  p:=0;
  for i:=0 to Image1.Height-1 do
  begin
    for j:=0 to Image1.Width do
    begin
      if Image1.Canvas.Pixels[j,i]=clWhite then
      begin
        p:=p+1;
        if p>12 then
        begin
          p:=p mod 12;
        end;
        LMark.Caption:=inttostr(p)+' отверстий';
        Mark(i,j,p);
      end;
      if Image1.Canvas.Pixels[j,i]=clBlack then
        Image1.Canvas.Pixels[j,i]:=clGray;
    end;
    FMain.Refresh;
    Application.ProcessMessages;
  end;
end;

procedure TFMain.BResetClick(Sender: TObject);
var
i,j: LongWord;
begin
  for i:=0 to Image1.Height-1 do
  begin
    for j:=0 to Image1.Width-1 do
      if (Image1.Canvas.Pixels[j,i]=clGray) or
         (Image1.Canvas.Pixels[j,i]=clBlack) then
        Image1.Canvas.Pixels[j,i]:=clBlack
      else
        Image1.Canvas.Pixels[j,i]:=clWhite;
    FMain.Refresh;
    Application.ProcessMessages;
  end;
end;

procedure TFMain.BSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Image1.Picture.SaveToFile(SaveDialog1.FileName);
end;

procedure TFMain.BStartClick(Sender: TObject);
  function Corners(i,j: LongWord): byte;
  var
  t: byte;
  w,b: byte;
  begin
    t:=0;
    w:=0; b:=0;
    if Image1.Canvas.Pixels[j,i]=clWhite then
      w:=w+1
    else
      b:=b+1;

    if Image1.Canvas.Pixels[j+1,i]=clWhite then
      w:=w+1
    else
      b:=b+1;

    if Image1.Canvas.Pixels[j,i+1]=clWhite then
      w:=w+1
    else
      b:=b+1;

    if Image1.Canvas.Pixels[j+1,i+1]=clWhite then
      w:=w+1
    else
      b:=b+1;

    if b=3 then
      t:=1;

    if w=3 then
      t:=2;

    Result:=t;

  end;
var
ec,ic: LongWord;
i,j: LongWord;
begin
  BResetClick(nil);
  ec:=0; ic:=0;
  for i:=0 to Image1.Height-1 do
  begin
    for j:=0 to Image1.Width-1 do
    begin
      if Corners(i,j)=1 then
        ec:=ec+1;
      if Corners(i,j)=2 then
        ic:=ic+1;
      if Image1.Canvas.Pixels[j,i]=clBlack then
        Image1.Canvas.Pixels[j,i]:=clGray
      else
        Image1.Canvas.Pixels[j,i]:=clSilver;
      LI.Caption:=inttostr(ic)+' внутренних углов';
      LE.Caption:=inttostr(ec)+' внешних углов';
      LResult.Caption:=inttostr((ec-ic) div 4)+' отверстий';
    end;
    FMain.Refresh;
    Application.ProcessMessages;
  end;
end;

procedure TFMain.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=false;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  AColor[1]:=clMaroon;
  AColor[2]:=clGreen;
  AColor[3]:=clOlive;
  AColor[4]:=clNavy;
  AColor[5]:=clPurple;
  AColor[6]:=clTeal;
  AColor[7]:=clRed;
  AColor[8]:=clLime;
  AColor[9]:=clYellow;
  AColor[10]:=clBlue;
  AColor[11]:=clFuchsia;
  AColor[12]:=clAqua;
  MD:=false;
  FillRect;
  FMain.DoubleBuffered:=true;
  SaveDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
  OpenPictureDialog1.InitialDir:=ExtractFilePath(Application.ExeName);
end;

procedure TFMain.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image1.Canvas.Pen.Color:=clBlack;
  Image1.Canvas.Brush.Color:=clBlack;
  PM:=Canvas.Pen.Mode;
  Image1.Canvas.Pen.Mode:=pmNotXor;
  XS:=X;
  YS:=Y;
  XO:=X;
  YO:=Y;
  MD:=true;
end;

procedure TFMain.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if MD then
  begin
    Image1.Canvas.Rectangle(XS,YS,XO,YO);
    Image1.Canvas.Rectangle(XS,YS,X,Y);
    XO:=X;
    YO:=Y
  end;
end;

procedure TFMain.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image1.Canvas.Pen.Mode:=PM;
  FMain.Image1.Canvas.Pen.Color:=clWhite;
  FMain.Image1.Canvas.Brush.Color:=clWhite;
  Image1.Canvas.Rectangle(XS,YS,X,Y);
  MD:=false;
end;

end.
