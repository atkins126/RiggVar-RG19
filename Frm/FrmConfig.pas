﻿unit FrmConfig;

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
{$ifdef fpc}
  LCLType,
{$else}
  Winapi.Windows,
{$endif}
  System.SysUtils,
  System.Classes,
  System.Types,
  System.UITypes,
  System.IniFiles,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Graphics,
  Vcl.Grids,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Buttons,
  Vcl.Menus,
  RggStrings,
  RggScroll,
  RggUnit4,
  RggTypes;

type

  { TFormConfig }

  TFormConfig = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    OKBtn: TButton;
    CancelBtn: TButton;

    PageControl: TPageControl;

    { Trimm }
    tsTrimm: TTabSheet;
    GroupBoxTrimm: TGroupBox;

    LabelMin: TLabel;
    LabelPos: TLabel;
    LabelMax: TLabel;

    MinEdit: TEdit;
    PosEdit: TEdit;
    MaxEdit: TEdit;

    LengthEditLabel: TLabel;

    TrimmComboLabel: TLabel;
    TrimmCombo: TComboBox;

    { Fachwerk / Material }
    tsFachwerk: TTabSheet;
    GroupBoxMaterial: TGroupBox;

    ElementLabel: TLabel;
    ElementCombo: TComboBox;

    EAEdit: TEdit;
    EAEditLabel: TLabel;
    TakeOverBtn: TButton;
    MaterialCombo: TComboBox;
    MaterialComboLabel: TLabel;
    QuerschnittComboLabel: TLabel;
    QuerschnittCombo: TComboBox;
    ALabel: TLabel;
    AEdit: TEdit;
    EEdit: TEdit;
    ELabel: TLabel;
    EEditLabel: TLabel;
    AEditLabel: TLabel;

    { Mast }
    tsMast: TTabSheet;
    GroupBoxMast: TGroupBox;

    MastTypeComboLabel: TLabel;
    MastTypeCombo: TComboBox;
    EIEdit: TEdit;
    EILabel: TLabel;

    MastMassComboLabel: TLabel;
    MastMassCombo: TComboBox;
    MastMassEdit: TEdit;
    MassMassEditLabel: TLabel;

    { Rumpf }
    tsRumpf: TTabSheet;
    GroupBoxRumpf: TGroupBox;

    Grid: TStringGrid;

    RumpfLabel: TLabel;
    RumpfEdit: TEdit;
    RumpfBtn: TButton;
    RumpfSpinEdit: TUpDown;

    { Ini Memo }
    tsIniMemo: TTabSheet;
    IniMemo: TMemo;
    SaveIniBtn: TButton;
    LoadIniBtn: TButton;

    procedure OKBtnClick(Sender: TObject);

    procedure MastMassEditExit(Sender: TObject);
    procedure MastMassEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MastTypeComboChange(Sender: TObject);
    procedure MastMassComboChange(Sender: TObject);

    procedure TrimmComboChange(Sender: TObject);
    procedure MinEditExit(Sender: TObject);
    procedure MinEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure QuerschnittComboChange(Sender: TObject);
    procedure MaterialComboChange(Sender: TObject);
    procedure ElementComboChange(Sender: TObject);
    procedure StoreItemClick(Sender: TObject);
    procedure LoadItemClick(Sender: TObject);
    procedure TakeOverBtnClick(Sender: TObject);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure RumpfBtnClick(Sender: TObject);
    procedure RumpfSpinEditChanging(Sender: TObject; var AllowChange: Boolean);
    procedure RumpfSpinEditEnter(Sender: TObject);
    procedure RumpfSpinEditExit(Sender: TObject);
  private
    FiMastSaling: Integer;
    FiMastWante: Integer;
    FiMastTop: Integer;
    FiEI: Integer;
    FEAarray: TRiggLvektor;

    FMastTypList: TStringList;
    FMastMassList: TStringList;
    FElementList: TStringList;
    FMaterialList: TStringList;
    FQuerschnittList: TStringList;
    FTrimmList: TStringList;
    FTempList: TStringList;

    FGSB: TRggFA;
    FiP: TRealRiggPoints;
    FRumpfCell: TPoint;

    FScale: single;
    function Scale(Value: Integer): Integer;

    procedure GetKeyList(Source, Dest: TStringList);
    procedure FillIniLists;
    procedure FillRiggLists;
    procedure LoadInifileCombos;
    procedure LoadRiggCombos;
    procedure CreateComponents;
    procedure LayoutComponents;
    procedure InitGrid;
    procedure SelectInitialCell;
  public
    FirstColumnIndex: Integer;
    FirstRowIndex: Integer;
    SecondRowIndex: Integer;
    Margin: Integer;
    Raster: Integer;

    Rigg: TRigg;
    IniFileName: string;
    FormShown: Boolean;
    procedure Init(ARigg: TRigg);
    procedure LoadFromIniFile;
    procedure WriteToIniFile;
  end;

var
  FormConfig: TFormConfig;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

uses
  RiggVar.App.Main,
  RiggVar.RG.Def;

procedure TFormConfig.FormCreate(Sender: TObject);
begin
  Caption := 'Form Config';

  FScale := MainVar.Scale;

  FMastTypList := TStringList.Create;
  FMastMassList := TStringList.Create;
  FElementList := TStringList.Create;
  FMaterialList := TStringList.Create;
  FQuerschnittList := TStringList.Create;
  FTrimmList := TStringList.Create;
  FTempList := TStringList.Create;

  FirstColumnIndex := 1;
  FirstRowIndex := 1; // 0 in FMX and 1 in VCL/LCL
  SecondRowIndex := FirstRowIndex + 1;

  FScale := MainVar.Scale;

  Margin := Round(10 * FScale);
  Raster := Round(70 * FScale);

  CreateComponents;

  PageControl.ActivePage := tsRumpf;
end;

procedure TFormConfig.FormDestroy(Sender: TObject);
begin
  FMastTypList.Free;
  FMastMassList.Free;
  FElementList.Free;
  FMaterialList.Free;
  FQuerschnittList.Free;
  FTrimmList.Free;
  FTempList.Free;
end;

procedure TFormConfig.GetKeyList(Source, Dest: TStringList);
var
  i: Integer;
  s: string;
begin
  Dest.Clear;
  for i := 0 to Source.Count - 1 do
  begin
    s := Copy(Source[i], 1, Pos('=', Source[i]) - 1);
    Dest.Add(s);
  end;
end;

procedure TFormConfig.InitGrid;
begin
  Grid.Left := Margin;
  Grid.Top := Margin;
  Grid.Width := Scale(263);
  Grid.Height := Scale(178);

  Grid.ColCount := 4;
  Grid.RowCount := 7;
  Grid.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected];
  Grid.ParentFont := True;
  Grid.ScrollBars := ssNone;
  Grid.TabOrder := 0;
  Grid.OnSelectCell := GridSelectCell;

  Grid.Cells[0,0] := '';
  Grid.Cells[1,0] := '    x';
  Grid.Cells[2,0] := '    y';
  Grid.Cells[3,0] := '    z';
  Grid.Cells[0,1] := '   A0';
  Grid.Cells[0,2] := '   B0';
  Grid.Cells[0,3] := '   C0';
  Grid.Cells[0,4] := '   D0';
  Grid.Cells[0,5] := '   E0';
  Grid.Cells[0,6] := '   F0';
end;

function TFormConfig.Scale(Value: Integer): Integer;
begin
  result := Round(Value * FScale);
end;

procedure TFormConfig.SelectInitialCell;
var
  b: Boolean;
begin
  b := True;
  FRumpfCell := Point(1, FirstRowIndex);
  GridSelectCell(nil, FRumpfCell.X, FRumpfCell.Y, b);
end;

procedure TFormConfig.Init(ARigg: TRigg);
begin
  Rigg := ARigg;
  IniFileName := ChangeFileExt(ParamStr(0), '.ini');

  SelectInitialCell;

  FillRiggLists;
  LoadRiggCombos;
  FillIniLists;
  LoadInifileCombos;
end;

procedure TFormConfig.FillRiggLists;
var
  fs: string;
begin
  FGSB := Rigg.GSB;
  FEAarray := Rigg.EA; { EA in KN }
  FiEI := Rigg.MastEI;
  FiMastSaling := Round(Rigg.MastUnten);
  FiMastWante := FiMastSaling + Round(Rigg.MastOben);
  FiMastTop := Round(Rigg.MastLaenge);
  FiP := Rigg.rP;

  FMastMassList.Clear;
  FElementList.Clear;
  FTrimmList.Clear;

  fs := '%s=%d';
  FMastMassList.Add(Format(fs, [MastComboTextSpreader, FiMastSaling]));
  FMastMassList.Add(Format(fs, [MastComboTextShroud, FiMastWante]));
  FMastMassList.Add(Format(fs, [MastComboTextTop, FiMastTop]));

  fs := '%s=%.6g';
  FElementList.Add(Format(fs, [ComboTextSpreader, FEAarray[7]]));
  FElementList.Add(Format(fs, [ComboTextVorstag, FEAarray[14]]));
  FElementList.Add(Format(fs, [ComboTextMast, FEAarray[0]]));
  FElementList.Add(Format(fs, [ComboTextSpreader, FEAarray[9]]));
  FElementList.Add(Format(fs, [ComboTextSpreaderConnection, FEAarray[11]]));
  FElementList.Add(Format(fs, [ComboTextHullRods, FEAarray[1]]));

  FTrimmList.Add(ControllerString);
  FTrimmList.Add(WinkelString);
  FTrimmList.Add(VorstagString);
  FTrimmList.Add(WanteString);
  FTrimmList.Add(WanteObenString);
  FTrimmList.Add(SalingHString);
  FTrimmList.Add(SalingAString);
  FTrimmList.Add(SalingLString);
end;

procedure TFormConfig.FillIniLists;
var
  ML: TStrings;
begin
  FMastTypList.Clear;
  FQuerschnittList.Clear;
  FMaterialList.Clear;

  if FileExists(InifileName) then
  begin
    LoadFromIniFile;
    if FMastTypList.Count = 0 then
      FMastTypList.Add('TestProfil=15000');
    if FQuerschnittList.Count = 0 then
      FQuerschnittList.Add('Rund D 4 mm=12.56');
    if FMaterialList.Count = 0 then
      FMaterialList.Add('Stahl=210');

    IniMemo.Lines.Clear;
    IniMemo.Lines.LoadFromFile(InifileName);

    Exit;
  end;

  { wenn Inifile nicht existiert dann Standardwerte laden }

  { EI in Nm^2 }
  ML := FMastTypList;
  ML.Add('PD=14700');
  ML.Add('PE=15000');
  ML.Add('PK=18000');

  { A in mm^2 }
  ML := FQuerschnittList;
  ML.Add('Rund D 4 mm=12.56');
  ML.Add('Rund D 10 mm=78.5');
  ML.Add('Profil=315');
  FQuerschnittList.Add('Faktor 100=100');

  { E in KN/mm^2 }
  ML := FMaterialList;
  ML.Add('Stahl=210');
  ML.Add('Niro=250');
  ML.Add('Alu=70');
  ML.Add('Kevlar=200');
  ML.Add(EA_S_Key + '=10');
  ML.Add(EA_M_Key + '=100');
  ML.Add(EA_L_Key + '=1000');

  ML := IniMemo.Lines;
  ML.Clear;
  ML.Add('[Profile]');
  ML.Add('Profil D=14700');
  ML.Add('Profil E=15000');
  ML.Add('Profil K=18000');
  ML.Add('');
  ML.Add('[Querschnitte]');
  ML.Add('Rund D 4 mm=12.56');
  ML.Add('Rund D 10 mm=78.5');
  ML.Add('Profil=315');
  ML.Add('Faktor 100=100');
  ML.Add('');
  ML.Add('[Material]');
  ML.Add('Stahl=210');
  ML.Add('Niro=250');
  ML.Add('Alu=70');
  ML.Add('Kevlar=200');
  ML.Add(EA_S_Key + '=10');
  ML.Add(EA_M_Key + '=100');
  ML.Add(EA_L_Key + '=1000');
end;

procedure TFormConfig.LoadRiggCombos;
var
  m: TRiggPoint;
  n: TKoord;
  c, r: Integer;
begin
  { Trimm }
  TrimmCombo.Items := FTrimmList;
  TrimmCombo.ItemIndex := Ord(fpWante);
  MinEdit.Text := IntToStr(Round(FGSB.Wante.Min));
  PosEdit.Text := IntToStr(Round(FGSB.Wante.Ist));
  MaxEdit.Text := IntToStr(Round(FGSB.Wante.Max));

  { elements }
  GetKeyList(FElementList, FTempList);
  ElementCombo.Items := FTempList;
  ElementCombo.ItemIndex := 0;
  EAEdit.Text := FElementList.Values[ElementCombo.Text];

  { mast length values }
  GetKeyList(FMastMassList, FTempList);
  MastMassCombo.Items := FTempList;
  MastMassCombo.ItemIndex := 0;
  MastMassEdit.Text := FMastMassList.Values[MastMassCombo.Text];

  { hull coordinates }
  r := FirstRowIndex - 1;
  for m := ooA0 to ooF0 do
  begin
    Inc(r);
    for n := x to z do
    begin
      c := Ord(n) + 1;
      Grid.Cells[c, r] := Format('%4.0f', [FiP[m, n]]);
    end;
  end;
end;

procedure TFormConfig.LoadIniFileCombos;
var
  i, j: Integer;
begin
  { Material }
  GetKeyList(FMaterialList, FTempList);
  MaterialCombo.Items := FTempList;
  MaterialCombo.ItemIndex := 0;
  EEdit.Text := FMaterialList.Values[MaterialCombo.Text];

  { Querschnitt }
  GetKeyList(FQuerschnittList, FTempList);
  QuerschnittCombo.Items := FTempList;
  QuerschnittCombo.ItemIndex := 0;
  AEdit.Text := FQuerschnittList.Values[QuerschnittCombo.Text];

  { MastTyp }
  GetKeyList(FMastTypList, FTempList);
  MastTypeCombo.Items := FTempList;
  j := 0;
  for i := 0 to FMastTypList.Count - 1 do
    if IntToStr(FiEI) = FMastTypList.Values[MastTypeCombo.Items[i]] then
      j := i;
  MastTypeCombo.ItemIndex := j;
  EIEdit.Text := FMastTypList.Values[MastTypeCombo.Text];
end;

procedure TFormConfig.LoadFromIniFile;
var
  IniFile: TMemIniFile;
begin
  IniFile := TMemIniFile.Create(IniFileName);
  try
    FMaterialList.Clear;
    IniFile.ReadSectionValues(Material_IniSectionString, FMaterialList);
    FQuerschnittList.Clear;
    IniFile.ReadSectionValues(Querschnitte_IniSectionString, FQuerschnittList);
    FMastTypList.Clear;
    IniFile.ReadSectionValues(Profile_IniSectionString, FMastTypList);
  finally
    IniFile.Free;
  end;
end;

procedure TFormConfig.WriteToIniFile;
begin
  IniMemo.Lines.SaveToFile(InifileName);
end;

procedure TFormConfig.LoadItemClick(Sender: TObject);
var
  s: string;
begin
  if FileExists(InifileName) then
  begin
    LoadFromIniFile;
    LoadInifileCombos;
    IniMemo.Lines.Clear;
    IniMemo.Lines.LoadFromFile(InifileName);
  end
  else
  begin
    s := ExtractFileName(InifileName);
    s := s + MsgStr_NotFound;
    MessageDlg(s, mtInformation, [mbOK], 0);
  end;
end;

procedure TFormConfig.StoreItemClick(Sender: TObject);
begin
  WriteToIniFile;
end;

procedure TFormConfig.TakeOverBtnClick(Sender: TObject);
var
  s: string;
  a, b, c: double;
begin
  { Values loaded from ini-file did contain wrong decimal separator}
  s := StringReplace(EEdit.Text, ',', '.', []);
  a := StrToFloat(s);
  s := StringReplace(AEdit.Text, ',', '.', []);
  b := StrToFloat(s);
  c := a * b;
  EAEdit.Text := Format('%.6g', [c]);

  s := ElementCombo.Text;
  if s = '' then
    Exit;

  if s = ComboTextHullRods then
  begin
    FEAarray[1] := c;
    FEAarray[2] := c;
    FEAarray[3] := c;
    FEAarray[4] := c;
    FEAarray[5] := c;
    FEAarray[6] := c;
  end
  else if s = ComboTextWanten then
  begin
    FEAarray[7] := c;
    FEAarray[8] := c;
    FEAarray[12] := c;
    FEAarray[13] := c;
  end
  else if s = ComboTextVorstag then
    FEAarray[14] := c
  else if s = ComboTextSpreader then
  begin
    FEAarray[9] := c;
    FEAarray[10] := c;
  end
  else if s = ComboTextSpreaderConnection then
    FEAarray[11] := c;

  FElementList.Values[s] := EAEdit.Text;
end;

procedure TFormConfig.TrimmComboChange(Sender: TObject);
var
  i: TFederParam;
  f: TRggSB;
begin
  i := TFederParam(TrimmCombo.ItemIndex);
  if i = TFederParam.fpWinkel then
    LengthEditLabel.Caption := LabelText_WinkelInGrad
  else
    LengthEditLabel.Caption := LabelText_DistanceInMM;

  f := FGSB.Find(i);
  MinEdit.Text := IntToStr(Round(f.Min));
  PosEdit.Text := IntToStr(Round(f.Ist));
  MaxEdit.Text := IntToStr(Round(f.Max));
end;

procedure TFormConfig.MinEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
    MinEditExit(Sender);
end;

procedure TFormConfig.MinEditExit(Sender: TObject);
var
  i: Integer;
  f: TRggSB;
  iMin, iIst, iMax: Integer;
  iVar: Integer;
begin
  i := TrimmCombo.ItemIndex;
  f := FGSB.Find(TFederParam(i));
  iMin := Round(f.Min);
  iIst := Round(f.Ist);
  iMax := Round(f.Max);

  if Sender = MinEdit then
  begin
    iVar := StrToIntDef(TEdit(Sender).Text, iMin);
    if iVar > iIst then
      iVar := iIst;
    f.Min := iVar;
    MinEdit.Text := IntToStr(iVar);
  end;

  if Sender = PosEdit then
  begin
    iVar := StrToIntDef(TEdit(Sender).Text, iIst);
    if iVar < iMin then
      iVar := iMin;
    if iVar > iMax then
      iVar := iMax;
    f.Ist := iVar;
    PosEdit.Text := IntToStr(iVar);
  end;

  if Sender = MaxEdit then
  begin
    iVar := StrToIntDef(TEdit(Sender).Text, iMax);
    if iVar < iIst then
      iVar := iIst;
    f.Max := iVar;
    MaxEdit.Text := IntToStr(iVar);
  end;
end;

procedure TFormConfig.MastMassEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
    MastMassEditExit(Sender);
end;

procedure TFormConfig.MastMassEditExit(Sender: TObject);
var
  i: Integer;
  temp: Integer;
  s: string;
begin
  s := MastMassCombo.Text;
  if s = '' then
    Exit;

  temp := 0;
  if s = MastComboTextSpreader then
    temp := FiMastSaling
  else if s = MastComboTextShroud then
    temp := FiMastWante
  else if s = MastComboTextTop then
    temp := FiMastTop;

  i := StrToIntDef(MastMassEdit.Text, temp);
  MastMassEdit.Text := IntToStr(i);

  FMastMassList.Values[s] := IntToStr(i);
  if s = MastComboTextSpreader then
    FiMastSaling := i
  else if s = MastComboTextShroud then
    FiMastWante := i
  else if s = MastComboTextTop then
    FiMastTop := i;
end;

procedure TFormConfig.OKBtnClick(Sender: TObject);
begin
  Rigg.rP := FiP; { Rumpfkoordinaten }
  Rigg.MastUnten := FiMastSaling;
  Rigg.MastOben := FiMastWante - FiMastSaling;
  Rigg.MastLaenge := FiMastTop;
  Rigg.GSB := FGSB; { neue Grenzen und Istwerte }
  Rigg.EA := FEAarray;
  Rigg.MastEI := FiEI;
end;

procedure TFormConfig.MastTypeComboChange(Sender: TObject);
begin
  EIEdit.Text := FMastTypList.Values[MastTypeCombo.Text];
  FiEI := StrToInt(EIEdit.Text);
end;

procedure TFormConfig.MastMassComboChange(Sender: TObject);
begin
  MastMassEdit.Text := FMastMassList.Values[MastMassCombo.Text];
end;

procedure TFormConfig.QuerschnittComboChange(Sender: TObject);
begin
  AEdit.Text := FQuerschnittList.Values[QuerschnittCombo.Text];
end;

procedure TFormConfig.MaterialComboChange(Sender: TObject);
begin
  EEdit.Text := FMaterialList.Values[MaterialCombo.Text];
end;

procedure TFormConfig.ElementComboChange(Sender: TObject);
begin
  EAEdit.Text := FElementList.Values[ElementCombo.Text];
end;

procedure TFormConfig.FormShow(Sender: TObject);
begin
  if not FormShown then
  begin
    LayoutComponents;
    FormShown := True;
  end;

  FillRiggLists;
  LoadRiggCombos;
  RumpfSpinEdit.Position := StrToIntDef(Grid.Cells[FRumpfCell.X,FRumpfCell.Y], 0);
  RumpfEdit.Text := Format('%4d mm',[RumpfSpinEdit.Position]);
end;

procedure TFormConfig.GridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  sRowHeaderText, sColHeaderText, sCellText: string;
begin
  CanSelect := True;

  if (ACol = 2) and (ARow > SecondRowIndex) then
    CanSelect := False;

  if CanSelect then
  begin
    FRumpfCell := Point(ACol, ARow);

    sRowHeaderText := TrimLeft(Grid.Cells[0, ARow]);
    sColHeaderText := TrimLeft(Grid.Cells[ACol, 0]);
    sCellText := Grid.Cells[ACol, ARow];

    RumpfLabel.Caption := Format('%s %s%s:', [FieldString, sRowHeaderText, sColHeaderText]);
    if RumpfSpinEdit <> nil then
    begin
      RumpfSpinEdit.Position := StrToIntDef(sCellText, 0);
      RumpfEdit.Text := Format('%4d mm', [RumpfSpinEdit.Position]);
    end;
  end;
end;

procedure TFormConfig.RumpfBtnClick(Sender: TObject);
var
  oo: TRiggPoint;
  kk: TKoord;
begin
  oo := TRiggPoint(FRumpfCell.Y - FirstRowIndex + Ord(ooA0));
  kk := TKoord(FRumpfCell.X - FirstColumnIndex);

  FiP[oo, kk] :=  RumpfSpinEdit.Position;
  Grid.Cells[FRumpfCell.X, FRumpfCell.Y] := Format('%4d', [RumpfSpinEdit.Position]);
  if FRumpfCell.Y = SecondRowIndex then
  begin
    FiP[ooA0] := FiP[ooB0];
    FiP[ooA0, y] := -FiP[ooB0, y];
    Grid.Cells[1, FirstRowIndex] := Format('%4.0f', [FiP[ooA0, x]]);
    Grid.Cells[2, FirstRowIndex] := Format('%4.0f', [FiP[ooA0, y]]);
    Grid.Cells[3, FirstRowIndex] := Format('%4.0f', [FiP[ooA0, z]]);
  end;
  if FRumpfCell.Y = FirstRowIndex then
  begin
    FiP[ooB0] := FiP[ooA0];
    FiP[ooB0, y] := -FiP[ooA0, y];
    Grid.Cells[1, SecondRowIndex] := Format('%4.0f', [FiP[ooB0, x]]);
    Grid.Cells[2, SecondRowIndex] := Format('%4.0f', [FiP[ooB0, y]]);
    Grid.Cells[3, SecondRowIndex] := Format('%4.0f', [FiP[ooB0, z]]);
  end;
end;

procedure TFormConfig.RumpfSpinEditChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  RumpfEdit.Text := Format('%4d mm',[RumpfSpinEdit.Position]);
end;

procedure TFormConfig.RumpfSpinEditEnter(Sender: TObject);
begin
  RumpfEdit.Color := clWindow;
end;

procedure TFormConfig.RumpfSpinEditExit(Sender: TObject);
begin
  RumpfEdit.Color := clBtnFace;
end;

procedure TFormConfig.CreateComponents;
var
  pc: TPageControl;
  ts: TTabSheet;
  gb: TGroupBox;
  ML: TStrings;
begin
  BorderIcons := [biSystemMenu, biMinimize];
  BorderStyle := bsDialog;
  Color := clBtnFace;

//  Font.Charset := DEFAULT_CHARSET;
//  Font.Color := clWindowText;
//  Font.Height := -11;
//  Font.Name := 'Tahoma';
//  Font.Style := [];

  FormStyle := fsStayOnTop;
  Position := poScreenCenter;
  PixelsPerInch := 96;

  OKBtn :=  TButton.Create(Self);
  OKBtn.Parent := Self;
  OKBtn.Caption := OKBtnCaption; //'OK';
  OKBtn.ModalResult := 1;

  CancelBtn := TButton.Create(Self);
  CancelBtn.Parent := Self;
  CancelBtn.Cancel := True;
  CancelBtn.Caption := CancelBtnCaption; //'Abbrechen';
  CancelBtn.Default := True;
  CancelBtn.ModalResult := 2;

  PageControl := TPageControl.Create(Self);
  pc := PageControl;
  pc.Parent := Self;

  { Page Trimm }

  tsTrimm := TTabSheet.Create(pc);
  tsTrimm.Caption := TrimmPageCaption; // 'Trimm';
  ts := tsTrimm;
  ts.PageControl := pc;

  GroupBoxTrimm := TGroupBox.Create(Self);
  GroupBoxTrimm.Caption := TrimmGroupBoxCaption; // 'Längen';
  gb := GroupBoxTrimm;
  gb.Parent := ts;

  LabelMin := TLabel.Create(Self);
  LabelMin.Parent := gb;
  LabelMin.Caption := MinLabelCaption; // 'Min';

  LabelPos := TLabel.Create(Self);
  LabelPos.Parent := gb;
  LabelPos.Caption := PosLabelCaption; // 'Pos';

  LabelMax := TLabel.Create(Self);
  LabelMax.Parent := gb;
  LabelMax.Caption := MaxLabelCaption; // 'Max';

  MinEdit := TEdit.Create(Self);
  MinEdit.Parent := gb;
  MinEdit.Text := '    ';

  PosEdit := TEdit.Create(Self);
  PosEdit.Parent := gb;
  PosEdit.Text := '    ';

  MaxEdit := TEdit.Create(Self);
  MaxEdit.Parent := gb;
  MaxEdit.Text := '    ';

  LengthEditLabel := TLabel.Create(Self);
  LengthEditLabel.Parent := gb;
  LengthEditLabel.Caption := LengthEditLabelCaption; // 'Abmessungen in mm';

  TrimmComboLabel := TLabel.Create(Self);
  TrimmComboLabel.Parent := gb;
  TrimmComboLabel.Caption := TrimmComboLabelCaption; // 'Trimmvariable';

  TrimmCombo := TComboBox.Create(Self);
  TrimmCombo.Parent := gb;
  TrimmCombo.Style := csDropDownList;
  ML := TrimmCombo.Items;
  ML.Add(ControllerString);
  ML.Add(WinkelString);
  ML.Add(VorstagString);
  ML.Add(WanteString);
  ML.Add(WanteObenString);
  ML.Add(SalingHString);
  ML.Add(SalingAString);
  ML.Add(SalingLString);

  { Page Fachwerk / Material }

  tsFachwerk := TTabSheet.Create(pc);
  tsFachwerk.Caption := FachwerkPageCaption; // 'Fachwerk';
  ts := tsFachwerk;
  ts.PageControl := pc;

  GroupBoxMaterial := TGroupBox.Create(Self);
  GroupBoxMaterial.Caption := GroupBoxMaterialCaption; // 'Material';
  gb := GroupBoxMaterial;
  gb.Parent := ts;

  ElementLabel := TLabel.Create(Self);
  ElementLabel.Parent := ts;
  ElementLabel.Caption := ElementLabelCaption; //'Fachwerkstäbe';

  ElementCombo := TComboBox.Create(Self);
  ElementCombo.Parent := ts;
  ElementCombo.Style := csDropDownList;
  ML := ElementCombo.Items;
  ML.Add(ComboTextHullRods);
  ML.Add(ComboTextWanten);
  ML.Add(ComboTextVorstag);
  ML.Add(ComboTextSpreader);
  ML.Add(ComboTextSpreaderConnection);

  EAEdit := TEdit.Create(Self);
  EAEdit.Parent := ts;
  EAEdit.Text := EAEditText; // 'EAEdit';
  EAEdit.Color := clBtnFace;
  EAEdit.ReadOnly := True;

  EAEditLabel := TLabel.Create(Self);
  EAEditLabel.Parent := ts;
  EAEditLabel.Caption := EAEditLabelCaption; // 'EA in KN';

  TakeOverBtn := TButton.Create(Self);
  TakeOverBtn.Parent := ts;
  TakeOverBtn.Caption := TakeOverBtnCaption; //'Auswahl übernehmen';

  MaterialCombo := TComboBox.Create(Self);
  MaterialCombo.Parent := gb;
  MaterialCombo.Style := csDropDownList;

  MaterialComboLabel := TLabel.Create(Self);
  MaterialComboLabel.Parent := gb;
  MaterialComboLabel.Caption := MaterialComboLabelCaption; // 'Material';

  QuerschnittComboLabel := TLabel.Create(Self);
  QuerschnittComboLabel.Parent := gb;
  QuerschnittComboLabel.Caption := QuerschnittComboLabelCaption; // 'Querschnitt';

  QuerschnittCombo := TComboBox.Create(Self);
  QuerschnittCombo.Parent := gb;
  QuerschnittCombo.Style := csDropDownList;

  ALabel := TLabel.Create(Self);
  ALabel.Parent := gb;
  ALabel.Caption := ALabelCaption; // 'A';

  AEdit := TEdit.Create(Self);
  AEdit.Parent := gb;
  AEdit.Text := AEditText; // 'AEdit';
  EAEdit.Color := clBtnFace;
  AEdit.ReadOnly := True;

  EEdit := TEdit.Create(Self);
  EEdit.Parent := gb;
  EEdit.Text := EEditText; //'EEdit';
  EAEdit.Color := clBtnFace;
  EEdit.ReadOnly := True;

  ELabel := TLabel.Create(Self);
  ELabel.Parent := gb;
  ELabel.Caption := ELabelCaption; // 'E';

  EEditLabel := TLabel.Create(Self);
  EEditLabel.Parent := gb;
  EEditLabel.Caption := EEditLabelCaption; // 'E-Modul in KN/mm^2';

  AEditLabel := TLabel.Create(Self);
  AEditLabel.Parent := gb;
  AEditLabel.Caption := AEditLabelCaption; // 'Querschnitt in mm^2';

  { Page Mast }

  tsMast := TTabSheet.Create(pc);
  tsMast.Caption := MastPageCaption; // 'Mast';
  ts := tsMast;
  ts.PageControl := pc;

  GroupBoxMast := TGroupBox.Create(Self);
  GroupBoxMast.Caption := GroupBoxMastCaption; // 'Mast';
  gb := GroupBoxMast;
  gb.Parent := ts;

  MastTypeComboLabel := TLabel.Create(Self);
  MastTypeComboLabel.Parent := gb;
  MastTypeComboLabel.Caption := MastTypeComboLabelCaption; // 'Profil';

  MastTypeCombo := TComboBox.Create(Self);
  MastTypeCombo.Parent := gb;
  MastTypeCombo.Style := csDropDownList;

  EIEdit := TEdit.Create(Self);
  EIEdit.Parent := gb;
  EIEdit.Text := EIEditText; // 'EIEdit';
  EIEdit.Color := clBtnFace;
  EIEdit.ReadOnly := True;

  EILabel := TLabel.Create(Self);
  EILabel.Parent := gb;
  EILabel.Caption := EILabelCaption; // 'Biegesteifigkeit EI in Nm^2';

  MastMassComboLabel := TLabel.Create(Self);
  MastMassComboLabel.Parent := gb;
  MastMassComboLabel.Caption := MastMassComboLabelCaption; //'Abmessungen';

  MastMassCombo := TComboBox.Create(Self);
  MastMassCombo.Parent := gb;
  MastMassCombo.Style := csDropDownList;
  ML := MastMassCombo.Items;
  ML.Add(MastComboTextController);
  ML.Add(MastComboTextSpreader);
  ML.Add(MastComboTextShroud);
  ML.Add(MastComboTextTop);

  MastMassEdit := TEdit.Create(Self);
  MastMassEdit.Parent := gb;

  MassMassEditLabel := TLabel.Create(Self);
  MassMassEditLabel.Parent := gb;
  MassMassEditLabel.Caption := MassMassEditLabelCaption; // 'Abstand vom Mastfuß in mm';

  { Page Rumpf }

  tsRumpf := TTabSheet.Create(pc);
  tsRumpf.Caption := HullPageCaption; // 'Rumpf';
  ts := tsRumpf;
  ts.PageControl := pc;

  GroupBoxRumpf := TGroupBox.Create(Self);
  GroupBoxRumpf.Caption := GroupBoxHullCaption; // 'Feld Editieren';
  gb := GroupBoxRumpf;
  gb.Parent := ts;

  RumpfLabel := TLabel.Create(Self);
  RumpfLabel.Parent := gb;
  RumpfLabel.WordWrap := False;
  RumpfLabel.AutoSize := True;

  RumpfEdit := TEdit.Create(Self);
  RumpfEdit.Parent := gb;
  RumpfEdit.Text := '10';
  RumpfEdit.ReadOnly := True;
  RumpfEdit.AutoSelect := False;

  RumpfBtn := TButton.Create(Self);
  RumpfBtn.Parent := gb;
  RumpfBtn.Caption := RumpfBtnCaption; // 'Übernehmen';

  RumpfSpinEdit := TUpDown.Create(Self);
  RumpfSpinEdit.Parent := gb;
  RumpfSpinEdit.Min := -32000;
  RumpfSpinEdit.Max := 32000;
  RumpfSpinEdit.Position := 10;
  RumpfSpinEdit.OnEnter := RumpfSpinEditEnter;
  RumpfSpinEdit.OnExit := RumpfSpinEditExit;

  Grid := TStringGrid.Create(Self);
  Grid.Parent := ts;
  InitGrid;

  { Page Ini }

  tsIniMemo := TTabSheet.Create(pc);
  tsIniMemo.Caption := IniMemoPageCaption; // 'Rigg.ini';
  ts := tsIniMemo;
  ts.PageControl := pc;

  IniMemo := TMemo.Create(Self);
  IniMemo.Parent := ts;

  SaveIniBtn := TButton.Create(Self);
  SaveIniBtn.Parent := ts;
  SaveIniBtn.Caption := SaveIniBtnCaption; // 'Speichern';

  LoadIniBtn := TButton.Create(Self);
  LoadIniBtn.Parent := ts;
  LoadIniBtn.Caption := LoadIniBtnCaption; // 'Laden';
end;

procedure TFormConfig.LayoutComponents;
begin
  Left := Scale(230);
  Top := Scale(113);

  PageControl.Left := Scale(8);
  PageControl.Top := Scale(8);
  PageControl.Width := Scale(521);
  PageControl.Height := Scale(265);
  PageControl.TabOrder := 0;

  { Trimm }

  GroupBoxTrimm.Left := Scale(16);
  GroupBoxTrimm.Top := Scale(16);
  GroupBoxTrimm.Width := Scale(473);
  GroupBoxTrimm.Height := Scale(169);
  GroupBoxTrimm.TabOrder := 0;

  LabelMin.Left := Scale(48);
  LabelMin.Top := Scale(46);
  LabelMin.Width := Scale(21);
  LabelMin.Height := Scale(16);

  LabelPos.Left := Scale(112);
  LabelPos.Top := Scale(46);
  LabelPos.Width := Scale(24);
  LabelPos.Height := Scale(16);

  LabelMax.Left := Scale(176);
  LabelMax.Top := Scale(46);
  LabelMax.Width := Scale(25);
  LabelMax.Height := Scale(16);

  MinEdit.Left := Scale(48);
  MinEdit.Top := Scale(64);
  MinEdit.Width := Scale(41);
  MinEdit.Height := Scale(21);
  MinEdit.MaxLength := 4;
  MinEdit.TabOrder := 1;
  MinEdit.OnExit := MinEditExit;
  MinEdit.OnKeyDown := MinEditKeyDown;

  PosEdit.Left := Scale(112);
  PosEdit.Top := Scale(64);
  PosEdit.Width := Scale(41);
  PosEdit.Height := Scale(21);
  PosEdit.MaxLength := 4;
  PosEdit.TabOrder := 2;
  PosEdit.OnExit := MinEditExit;
  PosEdit.OnKeyDown := MinEditKeyDown;

  MaxEdit.Left := Scale(176);
  MaxEdit.Top := Scale(64);
  MaxEdit.Width := Scale(41);
  MaxEdit.Height := Scale(21);
  MaxEdit.MaxLength := 4;
  MaxEdit.TabOrder := 0;
  MaxEdit.OnExit := MinEditExit;
  MaxEdit.OnKeyDown := MinEditKeyDown;

  LengthEditLabel.Left := Scale(228);
  LengthEditLabel.Top := Scale(65);
  LengthEditLabel.Width := Scale(125);
  LengthEditLabel.Height := Scale(16);

  TrimmComboLabel.Left := Scale(223);
  TrimmComboLabel.Top := Scale(112);
  TrimmComboLabel.Width := Scale(87);
  TrimmComboLabel.Height := Scale(16);

  TrimmCombo.Left := Scale(48);
  TrimmCombo.Top := Scale(111);
  TrimmCombo.Width := Scale(169);
  TrimmCombo.Height := Scale(21);
  TrimmCombo.TabOrder := 3;
  TrimmCombo.OnChange := TrimmComboChange;

  { Fachwerk }

  ElementLabel.Left := Scale(24);
  ElementLabel.Top := Scale(10);
  ElementLabel.Width := Scale(92);
  ElementLabel.Height := Scale(16);

  ElementCombo.Left := Scale(24);
  ElementCombo.Top := Scale(32);
  ElementCombo.Width := Scale(161);
  ElementCombo.Height := Scale(21);
  ElementCombo.TabOrder := 0;
  ElementCombo.OnChange := ElementComboChange;

  EAEdit.Left := Scale(200);
  EAEdit.Top := Scale(32);
  EAEdit.Width := Scale(105);
  EAEdit.Height := Scale(21);
  EAEdit.TabStop := False;
  EAEdit.TabOrder := 1;

  EAEditLabel.Left := Scale(200);
  EAEditLabel.Top := Scale(10);
  EAEditLabel.Width := Scale(52);
  EAEditLabel.Height := Scale(16);

  TakeOverBtn.Left := Scale(319);
  TakeOverBtn.Top := Scale(30);
  TakeOverBtn.Width := Scale(170);
  TakeOverBtn.Height := Scale(25);
  TakeOverBtn.TabOrder := 2;
  TakeOverBtn.OnClick := TakeOverBtnClick;

  GroupBoxMaterial.Left := Scale(24);
  GroupBoxMaterial.Top := Scale(74);
  GroupBoxMaterial.Width := Scale(477);
  GroupBoxMaterial.Height := Scale(151);
  GroupBoxMaterial.TabOrder := Scale(3);

  MaterialComboLabel.Left := Scale(31);
  MaterialComboLabel.Top := Scale(30);
  MaterialComboLabel.Width := Scale(48);
  MaterialComboLabel.Height := Scale(16);

  MaterialCombo.Left := Scale(31);
  MaterialCombo.Top := Scale(52);
  MaterialCombo.Width := Scale(153);
  MaterialCombo.Height := Scale(21);
  MaterialCombo.TabOrder := 0;
  MaterialCombo.OnChange := MaterialComboChange;

  ELabel.Left := Scale(198);
  ELabel.Top := Scale(31);
  ELabel.Width := Scale(9);
  ELabel.Height := Scale(16);

  EEdit.Left := Scale(198);
  EEdit.Top := Scale(53);
  EEdit.Width := Scale(73);
  EEdit.Height := Scale(21);
  EEdit.TabStop := False;
  EEdit.TabOrder := 3;

  EEditLabel.Left := EEdit.Left + EEdit.Width + Margin;
  EEditLabel.Top := EEdit.Top;
  EEditLabel.Width := Scale(124);
  EEditLabel.Height := Scale(16);

  QuerschnittComboLabel.Left := Scale(31);
  QuerschnittComboLabel.Top := Scale(92);
  QuerschnittComboLabel.Width := Scale(66);
  QuerschnittComboLabel.Height := Scale(16);

  QuerschnittCombo.Left := Scale(31);
  QuerschnittCombo.Top := Scale(114);
  QuerschnittCombo.Width := Scale(153);
  QuerschnittCombo.Height := Scale(21);
  QuerschnittCombo.TabOrder := 1;
  QuerschnittCombo.OnChange := QuerschnittComboChange;

  ALabel.Left := Scale(198);
  ALabel.Top := Scale(92);
  ALabel.Width := Scale(9);
  ALabel.Height := Scale(16);

  AEdit.Left := Scale(198);
  AEdit.Top := Scale(114);
  AEdit.Width := Scale(73);
  AEdit.Height := Scale(21);
  AEdit.TabStop := False;
  AEdit.TabOrder := 2;

  AEditLabel.Left := AEdit.Left + AEdit.Width + Margin;
  AEditLabel.Top := AEdit.Top;
  AEditLabel.Width := Scale(118);
  AEditLabel.Height := Scale(16);

  { Mast }

  GroupBoxMast.Left := Scale(18);
  GroupBoxMast.Top := Scale(23);
  GroupBoxMast.Width := Scale(471);
  GroupBoxMast.Height := Scale(194);
  GroupBoxMast.TabOrder := 0;

  MastTypeComboLabel.Left := Scale(24);
  MastTypeComboLabel.Top := Scale(38);
  MastTypeComboLabel.Width := Scale(30);
  MastTypeComboLabel.Height := Scale(16);

  MastTypeCombo.Left := Scale(24);
  MastTypeCombo.Top := Scale(56);
  MastTypeCombo.Width := Scale(145);
  MastTypeCombo.Height := Scale(21);
  MastTypeCombo.TabOrder := 2;
  MastTypeCombo.OnChange := MastTypeComboChange;

  EIEdit.Left := Scale(185);
  EIEdit.Top := Scale(56);
  EIEdit.Width := Scale(73);
  EIEdit.Height := Scale(21);
  EIEdit.TabStop := False;
  EIEdit.TabOrder := 3;

  EILabel.Left := Scale(264);
  EILabel.Top := Scale(57);
  EILabel.Width := Scale(158);
  EILabel.Height := Scale(16);

  MastMassComboLabel.Left := Scale(24);
  MastMassComboLabel.Top := Scale(110);
  MastMassComboLabel.Width := Scale(87);
  MastMassComboLabel.Height := Scale(16);

  MastMassCombo.Left := Scale(24);
  MastMassCombo.Top := Scale(132);
  MastMassCombo.Width := Scale(145);
  MastMassCombo.Height := Scale(21);
  MastMassCombo.TabOrder := 0;
  MastMassCombo.OnChange := MastMassComboChange;

  MastMassEdit.Left := Scale(185);
  MastMassEdit.Top := Scale(132);
  MastMassEdit.Width := Scale(73);
  MastMassEdit.Height := Scale(21);
  MastMassEdit.MaxLength := 4;
  MastMassEdit.TabOrder := 1;
  MastMassEdit.OnExit := MastMassEditExit;
  MastMassEdit.OnKeyDown := MastMassEditKeyDown;

  MassMassEditLabel.Left := Scale(264);
  MassMassEditLabel.Top := Scale(133);
  MassMassEditLabel.Width := Scale(167);
  MassMassEditLabel.Height := Scale(16);

  { Hull }

  GroupBoxRumpf.Left := Grid.Left + Grid.Width + Margin;
  GroupBoxRumpf.Top := Grid.Top;
  GroupBoxRumpf.Width := Scale(161);
  GroupBoxRumpf.Height := Scale(145);

  RumpfLabel.Left := Scale(24);
  RumpfLabel.Top := 2 * Margin;
  RumpfLabel.Width := Scale(73);
  RumpfLabel.Height := Scale(16);

  RumpfEdit.Left := RumpfLabel.Left;
  RumpfEdit.Top := RumpfLabel.Top + RumpfLabel.Height + Margin;
  RumpfEdit.Width := Scale(81);
  RumpfEdit.Height := Scale(24);
  RumpfEdit.TabOrder := 1;

  RumpfSpinEdit.TabOrder := 2;
  RumpfSpinEdit.TabStop := True;
  RumpfSpinEdit.OnChanging := RumpfSpinEditChanging;
  RumpfSpinEdit.Associate := RumpfEdit;

  RumpfBtn.Left := RumpfLabel.Left;
  RumpfBtn.Top := RumpfEdit.Top + RumpfEdit.Height + Margin;
  RumpfBtn.Width := Scale(129);
  RumpfBtn.Height := Scale(25);
  RumpfBtn.TabOrder := 0;
  RumpfBtn.OnClick := RumpfBtnClick;

  { Ini Memo }

  IniMemo.Left := 0;
  IniMemo.Top := 0;
  IniMemo.Width := Scale(393);
  IniMemo.Height := Scale(237);
  IniMemo.Align := alLeft;
  IniMemo.ScrollBars := ssVertical;
  IniMemo.TabOrder := 0;

  SaveIniBtn.Left := Scale(408);
  SaveIniBtn.Top := Scale(16);
  SaveIniBtn.Width := Scale(81);
  SaveIniBtn.Height := Scale(25);
  SaveIniBtn.TabOrder := 1;
  SaveIniBtn.OnClick := StoreItemClick;

  LoadIniBtn.Left := Scale(408);
  LoadIniBtn.Top := Scale(47);
  LoadIniBtn.Width := Scale(81);
  LoadIniBtn.Height := Scale(25);
  LoadIniBtn.TabOrder := 2;
  LoadIniBtn.OnClick := LoadItemClick;

  { Buttons }

  OKBtn.Left := Scale(169);
  OKBtn.Top := Scale(283);
  OKBtn.Width := Scale(81);
  OKBtn.Height := Scale(27);
  OKBtn.TabOrder := 1;
  OKBtn.OnClick := OKBtnClick;

  CancelBtn.Left := Scale(268);
  CancelBtn.Top := Scale(283);
  CancelBtn.Width := Scale(101);
  CancelBtn.Height := Scale(27);
  CancelBtn.TabOrder := 2;

  ClientHeight := Scale(318);
  ClientWidth := Scale(529);
end;

end.
