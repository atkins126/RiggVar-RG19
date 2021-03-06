﻿unit FrmMain;

(*
-
-     F
-    * * *
-   *   *   G
-  *     * *   *
- E - - - H - - - I
-  *     * *         *
-   *   *   *           *
-    * *     *             *
-     D-------A---------------B
-              *
-              (C) federgraph.de
-
*)

interface

{$ifdef fpc}
{$mode delphi}
{$endif}

{$define WantMenu}

uses
  RiggVar.App.Model,
  RiggVar.FB.SpeedColor,
  RiggVar.FB.SpeedBar,
  RiggVar.RG.Def,
  RiggVar.RG.Report,
  RiggVar.RG.Rota,
  RiggVar.FederModel.Menu,
  RggCtrls,
  RggChartGraph,
  RggTypes,
  RggInter,
  SysUtils,
  Classes,
  Types,
  UITypes,
  Controls,
  Forms,
  StdCtrls,
  ExtCtrls,
  Dialogs,
  Menus,
  Graphics;

{$define Vcl}

type
    TFormMain = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    procedure UpdateFormat(w, h: Integer);
    procedure GotoLandscape;
    procedure GotoNormal;
    procedure GotoPortrait;
    procedure GotoSquare;
    procedure InitScreenPos;
  private
    FScale: single;
    DefaultCaption: string;
    FormShown: Boolean;
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure FormCreate2(Sender: TObject);
    procedure FormDestroy2(Sender: TObject);
    procedure HandleShowHint(Sender: TObject);
    procedure Flash(s: string);
    procedure Reset;
    procedure PlaceImage(PosLeft, PosTop: Integer);
    procedure InitDebugInfo;
    procedure InitZOrderInfo;
    procedure ShowHelpText(fa: Integer);
    function GetCanShowMemo: Boolean;
  protected
    HelpTopic: Integer;
    ShowingHelp: Boolean;
    HL: TStringList;
    RL: TStrings;
    TL: TStrings;
    procedure InitParamListbox;
  public
    procedure ShowTrimm;
    procedure ShowTrimmData;
  private
    FWantButtonReport: Boolean;
    procedure UpdateReport;
    property WantButtonReport: Boolean read FWantButtonReport;
  public
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    function GetOpenFileName(dn, fn: string): string;
    function GetSaveFileName(dn, fn: string): string;
  public
    FocusContainer: TButton;
    HintContainer: TWinControl;
    HintText: TLabel;
    ReportText: TMemo;
    TrimmText: TMemo;
    ParamListbox: TListBox;
    ReportListbox: TListBox;
    ReportLabel: TLabel;
    function FindItemIndexOfParam(ML: TStrings): Integer;
    procedure UpdateItemIndexParams;
    procedure UpdateItemIndexParamsLB;
    procedure UpdateItemIndexReports;
    procedure UpdateItemIndexTrimms;
    procedure ParamListboxChange(Sender: TObject);
    procedure ReportListboxChange(Sender: TObject);
  public
    procedure ShowReport(const Value: TRggReport);
    function GetShowDataText: Boolean;
    function GetShowDiffText: Boolean;
    function GetShowTrimmText: Boolean;
    procedure SetShowDataText(const Value: Boolean);
    procedure SetShowDiffText(const Value: Boolean);
    procedure SetShowTrimmText(const Value: Boolean);
    property ShowTrimmText: Boolean read GetShowTrimmText write SetShowTrimmText;
    property ShowDiffText: Boolean read GetShowDiffText write SetShowDiffText;
    property ShowDataText: Boolean read GetShowDataText write SetShowDataText;
  public
    ComponentsCreated: Boolean;
    procedure UpdateParent;
    procedure CreateComponents;
    procedure CheckSpaceForImages;
    procedure CheckSpaceForMemo;
    procedure CheckSpaceForListbox;
    procedure SetupMemo(MM: TMemo);
    procedure SetupListbox(LB: TListBox);
  public
    Raster: Integer;
    Margin: Integer;
    ListboxWidth: Integer;
    ReportMemoWidth: Integer;
    SpeedPanelHeight: Integer;
    SpeedPanel: TActionSpeedBar;
    SpeedPanel01: TActionSpeedBar;
    SpeedPanel02: TActionSpeedBar;
    SpeedPanel03: TActionSpeedBar;
    SpeedPanel04: TActionSpeedBar;
    SpeedColorScheme: TSpeedColorScheme;
    procedure InitSpeedButtons;
    procedure LayoutSpeedPanel(SP: TActionSpeedBar);
    procedure ToggleSpeedPanel;
    procedure ToggleButtonSize;
    procedure SwapSpeedPanel(Value: Integer);
    procedure SwapRota(Value: Integer);
  public
    procedure ChartImageBtnClick(Sender: TObject);
    procedure SalingImageBtnClick(Sender: TObject);
    procedure ControllerImageBtnClick(Sender: TObject);

    procedure LineColorBtnClick(Sender: TObject);
    procedure SeiteBtnClick(Sender: TObject);
    procedure AchternBtnClick(Sender: TObject);
    procedure TopBtnClick(Sender: TObject);
    procedure NullBtnClick(Sender: TObject);

    procedure MemoryBtnClick(Sender: TObject);
    procedure MemoryRecallBtnClick(Sender: TObject);

    procedure SofortBtnClick(Sender: TObject);
    procedure GrauBtnClick(Sender: TObject);
    procedure BlauBtnClick(Sender: TObject);
    procedure MultiBtnClick(Sender: TObject);

    procedure BogenBtnClick(Sender: TObject);
    procedure KoppelBtnClick(Sender: TObject);
    procedure HullBtnClick(Sender: TObject);

    procedure SuperSimpleBtnClick(Sender: TObject);
    procedure SuperNormalBtnClick(Sender: TObject);
    procedure SuperGrauBtnClick(Sender: TObject);
    procedure SuperBlauBtnClick(Sender: TObject);
    procedure SuperMultiBtnClick(Sender: TObject);
    procedure SuperDisplayBtnClick(Sender: TObject);
    procedure SuperQuickBtnClick(Sender: TObject);
{$ifdef WantMenu}
  public
    MainMenu: TMainMenu;
    FederMenu: TFederMenu;
    procedure PopulateMenu;
{$endif}
  public
    procedure UpdateColorScheme;
    procedure LayoutComponents;
    function GetActionFromKey(Shift: TShiftState; Key: Word): Integer;
    function GetActionFromKeyChar(KeyChar: char): Integer;
    function GetChecked(fa: Integer): Boolean;
    procedure HandleAction(fa: Integer);
  public
    RotaForm: TRotaForm;
    procedure HandleSegment(fa: Integer);
  public
    Rigg: TRigg;
    RiggInter: IRigg;
    ReportManager: TRggReportManager;
    FViewPoint: TViewPoint;
    procedure UpdateOnParamValueChanged;
    procedure SetIsUp(const Value: Boolean);
    function GetIsUp: Boolean;
    procedure SetViewPoint(const Value: TViewPoint);
    property ViewPoint: TViewPoint read FViewPoint write SetViewPoint;
    property IsUp: Boolean read GetIsUp write SetIsUp;
    property CanShowMemo: Boolean read GetCanShowMemo;
  public
    Image: TImage;
    ImagePositionX: Integer;
    ImagePositionY: Integer;
    TextPositionX: Integer;
    TextPositionY: Integer;
    procedure UpdateFederText;
    procedure CenterRotaForm;
    procedure ToggleAllText;
  public
    SalingImage: TImage;
    SalingGraph: TSalingGraph;
    ControllerImage: TImage;
    ControllerGraph: TSalingGraph;
    ChartImage: TImage;
    ChartGraph: TChartGraph;
    ChartControl: TWinControl;
    procedure DoOnUpdateChart(Sender: TObject);
    procedure InitSalingGraph;
    procedure InitControllerGraph;
    procedure InitChartGraph;
    procedure UpdateSalingGraph;
    procedure UpdateControllerGraph;
    procedure UpdateChartGraph;
    procedure LayoutImages;
  protected
    procedure DestroyForms;
    procedure ShowDiagramC;
    procedure ShowDiagramE;
    procedure ShowDiagramQ;
    procedure ShowFormKreis;
    procedure MemoBtnClick(Sender: TObject);
    procedure ActionsBtnClick(Sender: TObject);
    procedure DrawingsBtnClick(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure TrimmTabBtnClick(Sender: TObject);
    procedure CheckFormBounds(AForm: TForm);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  FrmMemo,
  FrmAction,
  FrmDrawing,
  FrmConfig,
  FrmTrimmTab,
  FrmDiagramC,
  FrmDiagramE,
  FrmDiagramQ,
  FrmInfo,
  FrmKreis,
  RiggVar.RG.Main,
  RiggVar.RG.Speed01,
  RiggVar.RG.Speed02,
  RiggVar.RG.Speed03,
  RiggVar.RG.Speed04,
  RiggVar.App.Main,
  RiggVar.FB.ActionConst,
  RiggVar.FB.Classes;

const
  HelpCaptionText = 'RG67 - press ? for help';
  ApplicationTitleText = 'RG67';

{ TFormMain }

procedure TFormMain.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  if (Main <> nil) and (Main.Logger <> nil) then
    Main.Logger.Info(E.Message);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';

  SpeedColorScheme := TSpeedColorScheme.Create;
  SpeedColorScheme.InitDark;
  TActionSpeedBar.SpeedColorScheme := SpeedColorScheme;

  FormCreate2(Sender);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  MainVar.AppIsClosing := True;

  FormDestroy2(Sender);

  SpeedColorScheme.Free;
end;

procedure TFormMain.FormCreate2(Sender: TObject);
begin
{$ifdef Debug}
  ReportMemoryLeaksOnShutdown := True;
{$endif}

  DoubleBuffered := True;

  FScale := 1.0;
{$ifdef MSWindows}
//  if MainVar.WantScaling then
//    FScale := ScaleFactor;
{$endif}

  Application.OnException := ApplicationEventsException;

  FormMain := self;
  InitScreenPos;

  Margin := Round(5 * FScale);
  Raster := Round(MainVar.Raster * FScale);
  MainVar.Scale := FScale;
  MainVar.ScaledRaster := Raster;
  TKR := Round(TKR * FScale);

  SpeedPanelHeight := Raster - Round(FScale * Margin);
  ListboxWidth := Round(230 * FScale);

{$ifdef WantMenu}
  FederMenu := TFederMenu.Create;
  MainMenu := TMainMenu.Create(Application);
  Menu := MainMenu;
{$endif}

  CreateComponents;

  SetupMemo(ReportText);
  SetupMemo(TrimmText);

  SetupListbox(ParamListbox);
  SetupListbox(ReportListbox);

  Rigg := TRigg.Create;
  RiggInter := Rigg;
  Rigg.TrimmTabelle.FScale := FScale;
  Rigg.ControllerTyp := ctOhne;

  Main := TMain.Create(Rigg);
  Main.Logger.Verbose := True;
  Main.IsUp := True;

  RotaForm := TRotaForm.Create;
  RotaForm.Image := Image;
  RotaForm.Init;
  RotaForm.SwapRota(1);

  { Params }
  if ParamListbox <> nil then
  begin
    InitParamListbox;
    ParamListbox.OnClick := ParamListboxChange;
    ParamListbox.ItemIndex := ParamListbox.Items.IndexOf('Vorstag');
  end;

  { Reports }
  HL := TStringList.Create;
  RL := TStringList.Create;
  ReportManager := TRggReportManager.Create(RL);
  ReportManager.CurrentReport := rgDiffText;
  if ReportListbox <> nil then
  begin
    ReportManager.InitLB(ReportListbox.Items);
    ReportListbox.OnClick := ReportListboxChange;
    ReportListbox.ItemIndex := ReportListbox.Items.IndexOf(
    ReportManager.GetReportCaption(ReportManager.CurrentReport));
  end;

  TL := TStringList.Create;
  Main.UpdateTrimm0;
  ShowTrimm;

  Reset;

  InitSalingGraph;
  InitControllerGraph;
  InitChartGraph;

  Main.Draw;
  Main.MemoryBtnClick;

  Application.OnHint := HandleShowHint;
  InitSpeedButtons;
  UpdateColorScheme;

  SwapSpeedPanel(RotaForm.Current);

  Main.InitDefaultData;
  CenterRotaForm;
  Main.FixPoint := ooD0;
  Main.HullVisible := False;
  Main.OnUpdateChart := DoOnUpdateChart;
  Main.FederTextCheckState;

{$ifdef WantMenu}
  PopulateMenu;
{$endif}
end;

procedure TFormMain.FormDestroy2(Sender: TObject);
begin
  DestroyForms;

  TL.Free;
  RL.Free;
  HL.Free;
  ReportManager.Free;

  Main.Free;
  Main := nil;

  SalingGraph.Free;
  ControllerGraph.Free;
  ChartGraph.Free;

  RotaForm.Free;
{$ifdef WantMenu}
  FederMenu.Free;
{$endif}
end;

procedure TFormMain.FormKeyPress(Sender: TObject; var Key: Char);
var
  fa: Integer;
begin
  fa := GetActionFromKeyChar(Key);

  if fa <> faNoop then
  begin
    Main.ActionHandler.Execute(fa);
  end;
end;

procedure TFormMain.UpdateOnParamValueChanged;
begin
  ShowTrimm;
  UpdateSalingGraph;
  UpdateControllerGraph;
  UpdateChartGraph;
end;

procedure TFormMain.UpdateReport;
begin
  if not FormShown then
    Exit;

  if ShowingHelp then
    Exit;
  if ReportText = nil then
    Exit;
  if not ReportText.Visible then
    Exit;
  if ReportManager = nil then
    Exit;
  if RL = nil then
    Exit;
  if not IsUp then
    Exit;

  RL.Clear;

  if WantButtonReport then
  begin
    Main.FederText.Report(RL);
    ReportText.Text := RL.Text;
  end
  else
  begin
    ReportManager.ShowCurrentReport;
    ReportText.Text := RL.Text;
  end;
end;

procedure TFormMain.UpdateFormat(w, h: Integer);
begin
  ClientWidth := w;
  ClientHeight := h;
  Flash(Format('%d x %d', [ClientWidth, ClientHeight]));
end;

procedure TFormMain.UpdateItemIndexParams;
begin
  UpdateItemIndexParamsLB;
  ShowTrimm;
end;

procedure TFormMain.UpdateItemIndexParamsLB;
var
  ii: Integer;
  ik: Integer;
begin
  if ParamListbox = nil then
    Exit;
  ii := ParamListbox.ItemIndex;
  ik := FindItemIndexOfParam(ParamListbox.Items);
  if ii <> ik then
  begin
    ParamListbox.OnClick := nil;
    ParamListbox.ItemIndex := ik;
    ParamListbox.OnClick := ParamListboxChange;
  end;
end;

function TFormMain.FindItemIndexOfParam(ML: TStrings): Integer;
var
  fp: TFederParam;
  i: Integer;
begin
  fp := Main.Param;
  result := -1;
  for i := 0 to ML.Count-1 do
  begin
    if TFederParam(ML.Objects[i]) = fp then
    begin
      result := i;
      break;
    end;
  end;
end;

procedure TFormMain.UpdateItemIndexReports;
var
  ii: Integer;
  ij: Integer;
begin
  if ReportListbox = nil then
    Exit;
  ii := ReportListbox.ItemIndex;
  ij := ReportManager.GetItemIndexOfReport(ReportManager.CurrentReport);
  if ii <> ij then
  begin
    ReportListbox.OnClick := nil;
    ReportListbox.ItemIndex := ij;
    ReportListbox.OnClick := ReportListboxChange;
  end;
end;

procedure TFormMain.UpdateItemIndexTrimms;
begin
end;

procedure TFormMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
    Main.DoMouseWheel(Shift, WheelDelta);
    Handled := True;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  if not FormShown then
  begin
    FormShown := True;
    UpdateParent;

    { ClientHeigt is now available }
    LayoutComponents;
    LayoutImages;

    UpdateReport;

    RotaForm.IsUp := True;
    RotaForm.Draw;

    FocusContainer.SetFocus;
  end;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  if (Main <> nil) and Main.IsUp then
  begin
//    if MainVar.WantScaling then
//      MainVar.Scale := ScaleFactor;
    Inc(Main.ResizeCounter);
    Main.UpdateTouch;
    UpdateFederText;
  end;

  if FormShown then
  begin
    CheckSpaceForListbox;
    CheckSpaceForMemo;
    CheckSpaceForImages;

    UpdateReport;
    SpeedPanel.UpdateLayout;
  end;
end;

procedure TFormMain.CheckSpaceForListbox;
begin
  if not FormShown then
    Exit;
  ReportListbox.Visible := ClientHeight > 910 * FScale;
end;

procedure TFormMain.PlaceImage(PosLeft, PosTop: Integer);
begin
  Image.Anchors := [];
  Image.Left := PosLeft;
  Image.Top := PosTop;
  Image.Width := ClientWidth - Image.Left - Raster - Margin;
  Image.Height := ClientHeight - Image.Top - Raster - Margin;
  if Image.Width > RotaForm.RotaForm1.BitmapWidth * FScale then
   Image.Width := Round(RotaForm.RotaForm1.BitmapWidth * FScale);
  if Image.Height > RotaForm.RotaForm1.BitmapHeight * FScale then
   Image.Height := Round(RotaForm.RotaForm1.BitmapHeight * FScale);
  Image.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];
end;

procedure TFormMain.CheckSpaceForMemo;
var
  PosLeft, PosTop: Integer;
begin
  if not FormShown then
    Exit;
  if not ComponentsCreated then
    Exit;

  UpdateParent;

  if not CanShowMemo then
  begin
    if RotaForm.LegendItemChecked then
    begin
      RotaForm.LegendBtnClick(nil);
    end;

    SpeedPanel.Visible := False;

    TrimmText.Visible := False;
    ParamListbox.Visible := False;
    if ReportListbox <> nil then
      ReportListbox.Visible := False;

    ReportText.Visible := False;
    ReportText.Anchors := [];

    FocusContainer.Left := Raster + Margin;
    FocusContainer.Visible := Width - 2 * Raster > FocusContainer.Width;

    HintContainer.Left := 2 * Raster + Margin;
    HintContainer.Visible := Width - 2 * Raster > HintContainer.Width;

    PosLeft := Raster + Margin;
    PosTop := 2 * Raster + Margin;
    if HintContainer.Visible then
      PosTop := HintContainer.Top + HintContainer.Height + Margin;
    PlaceImage(PosLeft, PosTop);
  end
  else
  begin
    SpeedPanel.Visible := True;
    SpeedPanel.Width := ClientWidth - 3 * Raster - Margin;

    TrimmText.Visible := True;
    ParamListbox.Visible := True;
    ReportListbox.Visible := True;

    ReportListbox.Anchors := [];
    ReportListbox.Left := ParamListbox.Left;
    ReportListbox.Top := ParamListbox.Top + ParamListbox.Height + Margin;
    ReportListbox.Width := ParamListbox.Width;
    ReportListbox.Height := ClientHeight - ReportListbox.Top - Raster - Margin;
    ReportListbox.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];

    FocusContainer.Visible := True;
    FocusContainer.Left := TrimmText.Left + TrimmText.Width + Margin;

    HintContainer.Visible := True;
    HintContainer.Left := FocusContainer.Left + FocusContainer.Width + Margin;

    ReportText.Visible := True;
    ReportText.Anchors := [];
    ReportText.Left := TrimmText.Left + TrimmText.Width + Margin;
    ReportText.Top := HintContainer.Top + HintContainer.Height + Margin;
    ReportText.Height := ClientHeight - ReportText.Top - Raster - Margin;
    ReportText.Width := ReportMemoWidth;
    ReportText.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];

    PlaceImage(ImagePositionX, ImagePositionY);
  end;
end;

procedure TFormMain.CheckSpaceForImages;
begin
  if not ComponentsCreated then
    Exit;

  { At aplication start up FormResize is called serveral times,
    but always before FormShow always called. }

  { ClientWidth and ClientHeight are not yet available when starting up.
    ClientHeigt is available when FormShow is called. }

  if FormShown then
  begin
    { when FormResize is called after FormShow }
    if (ChartControl.Left + ChartControl.Width > ClientWidth - Raster) or
       (ChartControl.Top + ChartControl.Height > ClientHeight - Raster) then
      ChartControl.Visible := False;

    if (ControllerImage.BoundsRect.Left < ReportText.BoundsRect.Right) or
       (ControllerImage.BoundsRect.Bottom > ClientHeight - Raster) then
      ControllerImage.Visible := False;

    if (SalingImage.BoundsRect.Left < ReportText.BoundsRect.Right) or
       (SalingImage.BoundsRect.Bottom > ClientHeight - Raster) then
      SalingImage.Visible := False;
  end
  else
  begin
    { when FormResize is called before FormShow }
    if (Width < 1200) or (Height < 600) then
      ChartControl.Visible := False;
    if (Width < 1500) or (Height < 655) then
      ControllerImage.Visible := False;
    if (Width < 1500) or (Height < 875) then
      SalingImage.Visible := False;
  end;

  Main.FederTextCheckState;
end;

procedure TFormMain.Reset;
begin
  HelpTopic := faShowHelpText;
  DefaultCaption := ApplicationTitleText;
  Flash(DefaultCaption);
end;

procedure TFormMain.GotoNormal;
begin
  if WindowState = TWindowState.wsMaximized then
    WindowState := TWindowState.wsNormal;
end;

procedure TFormMain.GotoLandscape;
begin
  GotoNormal;
  if Screen.Width > Screen.Height then
  begin
    Height := Round(Screen.WorkAreaHeight);
    ClientWidth := Round(ClientHeight * 4 / 3);
    Top := 0;
  end
  else
  begin
    Width := Round(Screen.WorkAreaWidth);
    ClientHeight := Round(ClientWidth * 3 / 4);
    Left := 0;
  end;
  Flash('Landscape');
end;

procedure TFormMain.GotoPortrait;
begin
  GotoNormal;
  if Screen.Width > Screen.Height then
  begin
    Height := Round(Screen.WorkAreaHeight);
    ClientWidth := Round(ClientHeight * 3 / 4);
    Top := 0;
  end
  else
  begin
    Width := Round(Screen.WorkAreaWidth);
    ClientHeight := Round(ClientWidth * 4 / 3);
    Left := 0;
    Top := 0;
  end;
  Flash('Portrait');
end;

procedure TFormMain.GotoSquare;
begin
  GotoNormal;
  if Screen.Width > Screen.Height then
  begin
    Height := Round(Screen.WorkAreaHeight);
    ClientWidth := Round(ClientHeight);
    Top := 0;
  end
  else
  begin
    Width := Round(Screen.WorkAreaWidth);
    ClientHeight := Round(ClientWidth);
    Left := 0
  end;
  Flash('Square');
end;

procedure TFormMain.Flash(s: string);
begin
  Caption := s;
end;

procedure TFormMain.HandleShowHint(Sender: TObject);
begin
  HintText.Caption := Application.Hint;
end;

procedure TFormMain.HandleAction(fa: Integer);
begin
  case fa of
    faToggleAllText: ToggleAllText;
    faToggleSpeedPanel: ToggleSpeedPanel;
    faToggleButtonSize: ToggleButtonSize;

    faToggleHelp:
    begin
      ShowingHelp := not ShowingHelp;
      if ShowingHelp then
         ShowHelpText(HelpTopic)
      else
        UpdateReport;
    end;

    faMemeGotoLandscape: GotoLandscape;
    faMemeGotoPortrait: GotoPortrait;
    faMemeGotoSquare: GotoSquare;

    faToggleReport:
    begin
      Flash(HelpCaptionText);
      ShowingHelp := False;
      UpdateReport;
    end;

    faMemeFormat1: UpdateFormat(1000, 750);
    faMemeFormat2: UpdateFormat(800, 600);
    faMemeFormat3: UpdateFormat(640, 480);
    faMemeFormat4: UpdateFormat(480, 480);
    faMemeFormat5: UpdateFormat(512, 512);
    faMemeFormat6: UpdateFormat(600, 600);
    faMemeFormat7: UpdateFormat(700, 700);
    faMemeFormat8: UpdateFormat(800, 800);
    faMemeFormat9: UpdateFormat(900, 900);
    faMemeFormat0:
    begin
      Top := 0;
      UpdateFormat(750, 1000)
    end;

    faToggleButtonReport:
    begin
      FWantButtonReport := not WantButtonReport;
      UpdateReport;
    end;

    faReportNone..faReportReadme:
    begin
      ReportManager.HandleAction(fa);
      UpdateReport;
    end;

    faChartRect..faChartReset: ChartGraph.HandleAction(fa);

    faToggleLineColor: LineColorBtnClick(nil);

    faToggleSegmentF..faToggleSegmentA: HandleSegment(fa);

    faRggZoomIn: RotaForm.ZoomInBtnClick(nil);
    faRggZoomOut: RotaForm.ZoomOutBtnClick(nil);

    faToggleUseDisplayList:
    begin
      RotaForm.UseDisplayListBtnClick(nil);
    end;

    faToggleSortedRota: RotaForm.HandleAction(fa);
    faToggleShowLegend: RotaForm.LegendBtnClick(nil);
    faToggleUseQuickSort: RotaForm.UseQuickSortBtnClick(nil);
    faToggleSalingGraph: SalingImageBtnClick(nil);
    faToggleControllerGraph: ControllerImageBtnClick(nil);
    faToggleChartGraph: ChartImageBtnClick(nil);
    faToggleMatrixText: RotaForm.MatrixItemClick(nil);

    faMemoryBtn: MemoryBtnClick(nil);
    faMemoryRecallBtn: MemoryRecallBtnClick(nil);

    faRggBogen: BogenBtnClick(nil);
    faRggKoppel: KoppelBtnClick(nil);
    faRggHull: HullBtnClick(nil);

    faSofortBtn: SofortBtnClick(nil);
    faGrauBtn: GrauBtnClick(nil);
    faBlauBtn: BlauBtnClick(nil);
    faMultiBtn: MultiBtnClick(nil);

    faSuperSimple: SuperSimpleBtnClick(nil);
    faSuperNormal: SuperNormalBtnClick(nil);
    faSuperGrau: SuperGrauBtnClick(nil);
    faSuperBlau: SuperBlauBtnClick(nil);
    faSuperMulti: SuperMultiBtnClick(nil);
    faSuperDisplay: SuperDisplayBtnClick(nil);
    faSuperQuick: SuperQuickBtnClick(nil);

    faShowMemo: MemoBtnClick(nil);
    faShowActions: ActionsBtnClick(nil);
    faShowDrawings: DrawingsBtnClick(nil);
    faShowConfig: ConfigBtnClick(nil);
    faShowTrimmTab: TrimmTabBtnClick(nil);

    faShowDiagC: ShowDiagramC;
    faShowDiagE: ShowDiagramE;
    faShowDiagQ: ShowDiagramQ;

    faShowKreis: ShowFormKreis;
    faShowInfo: ShowInfo;

    faToggleSandboxed: MainVar.IsSandboxed := MainConst.MustBeSandboxed or (not MainVar.IsSandboxed);
    faToggleAllProps: MainVar.AllProps := not MainVar.AllProps;
    faToggleAllTags: MainVar.AllTags := not MainVar.AllTags;

    faRotaForm1: SwapRota(1);
    faRotaForm2: SwapRota(2);
    faRotaForm3: SwapSpeedPanel(3); // SwapRota(3);

    faReset,
    faResetPosition,
    faResetRotation,
    faResetZoom: RotaForm.HandleAction(fa);

    faPan:
    begin
      Main.SetParameter(faPan);
      ShowTrimm;
    end;

    faShowZOrderInfo,
    faShowNormalKeyInfo,
    faShowSpecialKeyInfo,
    faShowDebugInfo,
    faShowInfoText,
    faShowHelpText: ShowHelpText(fa);

    else
    begin
      { do nothing }
    end;

  end;
end;

function TFormMain.GetActionFromKey(Shift: TShiftState; Key: Word): Integer;
begin
  result := faNoop;
  case Key of
    vkF12: result := faMemeGotoSquare;
//    vkC: result := faCopyTrimmItem;
//    vkV: result := faPasteTrimmItem;
    vkEscape:
    begin
      if Shift = [ssShift] then
        result := faResetPosition
      else
        result := faReset;
    end;
  end;
end;

function TFormMain.GetActionFromKeyChar(KeyChar: char): Integer;
var
  fa: Integer;
begin
  fa := faNoop;
  case KeyChar of
    'a': fa := faSalingA;
    'A': fa := faFixpointA0;

    'b': fa := faBiegung;
    'B': fa := faFixpointB0;

    'c': fa := faMastfallF0C;
    'C': fa := faFixpointC0;

    'd': fa := faFixpointD;
    'D': fa := faFixpointD0;

    'e': fa := faFixpointE;
    'E': fa := faFixpointE0;

    'f': fa := faMastfallF0F;
    'F': fa := faFixpointF0;

    'g': fa := faMastfallVorlauf;

    'h': fa := faSalingH;
    'H': fa := faToggleHelp;

    'i': fa := faWheelRight;
    'I': fa := faWheelLeft;

    'j': fa := faWheelUp;
    'J': fa := faWheelDown;

    'k': ;
    'K': fa := faRggKoppel;

    'l': fa := faToggleShowLegend;
    'L': fa := faMemeGotoLandscape;

    'm': fa := faMemoryBtn;
    'M': fa := faCopyAndPaste;

    'n': fa := faShowNormalKeyInfo;

    'o': fa := faWoben;

    'p': fa := faPan;
    'P': fa := faMemeGotoPortrait;

    'q': fa := faToggleAllText;

    'r': fa := faToggleReport;
    'R': fa := faReadTrimmFile;

    's': fa := faShowSpecialKeyInfo;
    'S': fa := faMemeGotoSquare;

    't': fa := faToggleDarkMode;
    'T': fa := faToggleSpeedPanel;

    'u': fa := faToggleDataText;
    'U': fa := faToggleDiffText;

    'v': fa := faVorstag;

    'w': fa := faWante;

    'z': fa := faShowInfoText;
    'Z': fa := faUpdateTrimm0;

    '0': fa := faTrimm0;
    '1': fa := faTrimm1;
    '2': fa := faTrimm2;
    '3': fa := faTrimm3;
    '4': fa := faTrimm4;
    '5': fa := faTrimm5;
    '6': fa := faTrimm6;
    '7': fa := fa420;
    '8': fa := faLogo;
    '9': ;

    '!': fa := faShowNormalKeyInfo;
    '"': fa := faShowSpecialKeyInfo;
    '§': fa := faShowInfoText;
    '$': fa := faShowDebugInfo;
    '=': fa := faShowZOrderInfo;
    '?': fa := faShowHelpText;

    '+': fa := faActionPageP;
    '*': fa := faActionPageM;

    '#': fa := faActionPage4;

    ',': fa := faRotaForm1;
    '.': fa := faRotaForm2;
    '-': fa := faRotaForm3;

    ';': fa := faRotaForm1;
    ':': fa := faRotaForm2;
    '_': fa := faRotaForm3;

    else fa := faNoop;

  end;
  result := fa;
end;

function TFormMain.GetIsUp: Boolean;
begin
  if not MainVar.AppIsClosing and Assigned(Main) then
    result := Main.IsUp
  else
    result := False;
end;

procedure TFormMain.SetIsUp(const Value: Boolean);
begin
  Main.IsUp := Value;
end;

function TFormMain.GetOpenFileName(dn, fn: string): string;
begin
  if not Assigned(OpenDialog) then
    OpenDialog := TOpenDialog.Create(self);

  OpenDialog.Options := [
    TOpenOption.ofPathMustExist,
    TOpenOption.ofFileMustExist,
    TOpenOption.ofNoNetworkButton,
    TOpenOption.ofEnableSizing];
  OpenDialog.Filter := 'Trimm-File|*.txt|Trimm-Datei|*.trm';
  OpenDialog.InitialDir := ExcludeTrailingPathDelimiter(dn);
  OpenDialog.FileName := fn;

  if OpenDialog.Execute then
    result := OpenDialog.FileName
  else
    result := '';
end;

function TFormMain.GetSaveFileName(dn, fn: string): string;
begin
  if not Assigned(SaveDialog) then
    SaveDialog := TSaveDialog.Create(self);

  SaveDialog.Options := [
    TOpenOption.ofHideReadOnly,
    TOpenOption.ofPathMustExist,
    TOpenOption.ofNoReadOnlyReturn,
    TOpenOption.ofNoNetworkButton,
    TOpenOption.ofEnableSizing];
  SaveDialog.Filter := 'Trimm-File|*.txt|Trimm-Datei|*.trm';
  SaveDialog.InitialDir := ExcludeTrailingPathDelimiter(dn);
  SaveDialog.FileName := fn;

  if SaveDialog.Execute then
    result := SaveDialog.FileName
  else
    result := '';
end;

function TFormMain.GetShowDataText: Boolean;
begin
  result := ReportText.Visible and (ReportManager.CurrentReport = TRggReport.rgDataText);
end;

function TFormMain.GetShowDiffText: Boolean;
begin
  result := ReportText.Visible and (ReportManager.CurrentReport = TRggReport.rgDiffText);
end;

function TFormMain.GetShowTrimmText: Boolean;
begin
  result := ReportText.Visible and (ReportManager.CurrentReport = TRggReport.rgTrimmText);
end;

procedure TFormMain.ShowReport(const Value: TRggReport);
begin
  ReportText.Visible := True;
  ReportManager.CurrentReport := Value;
  UpdateReport;
  UpdateItemIndexReports;
end;

procedure TFormMain.SetShowDataText(const Value: Boolean);
begin
  if Value then
  begin
    ShowingHelp := False;
    ShowReport(TRggReport.rgDataText);
  end
  else
  begin
    ReportText.Visible := False;
  end;
end;

procedure TFormMain.SetShowDiffText(const Value: Boolean);
begin
  if Value then
  begin
    ShowingHelp := False;
    ShowReport(TRggReport.rgDiffText);
  end
  else
  begin
    ReportText.Visible := False;
  end;
end;

procedure TFormMain.SetShowTrimmText(const Value: Boolean);
begin
  if Value then
  begin
    ShowingHelp := False;
    ShowReport(TRggReport.rgTrimmText);
  end
  else
  begin
    ReportText.Visible := False;
  end;
end;

procedure TFormMain.SetupListbox(LB: TListBox);
begin
  if LB = nil then
    Exit;

  LB.Font.Name := 'Consolas';
  LB.Font.Size := 11;
  LB.Font.Color := TColors.Blue;
end;

procedure TFormMain.SetupMemo(MM: TMemo);
begin
  if MM = nil then
    Exit;

  MM.Parent := Self;
  MM.Font.Name := 'Consolas';
  MM.Font.Size := 11;
  MM.Font.Color := TColors.Teal;
  MM.ScrollBars := ssBoth;
end;

procedure TFormMain.CreateComponents;
begin
  FocusContainer := TButton.Create(Self);
  FocusContainer.Name := 'FocusContainer';
  FocusContainer.Parent := Self;
  FocusContainer.TabStop := True;
  FocusContainer.Caption := '';

  HintContainer := TWinControl.Create(Self);
  HintContainer.Name := 'HintContainer';
  HintContainer.Parent := Self;

  HintText := TLabel.Create(Self);
  HintText.Name := 'HintText';
  HintText.Parent := HintContainer;
  HintText.Font.Name := 'Consolas';
  HintText.Font.Size := 14;
  HintText.Font.Color := TColors.OrangeRed;
  HintText.AutoSize := True;
  HintText.WordWrap := False;

  ReportText := TMemo.Create(Self);
  ReportText.Name := 'ReportText';
  SetupMemo(ReportText);

  TrimmText := TMemo.Create(Self);
  SetupMemo(TrimmText);
  TrimmText.ReadOnly := True;
  TrimmText.TabStop := False;

  Image := TImage.Create(Self);
  Image.Name := 'Image';
  Image.Parent := Self;

  SpeedPanel01 := TActionSpeedBarRG01.Create(Self);
  SpeedPanel01.Name := 'SpeedPanel01';
  SpeedPanel01.Parent := Self;
  SpeedPanel01.ShowHint := True;
  SpeedPanel01.Visible := False;
  SpeedPanel01.Caption := '';

  SpeedPanel02 := TActionSpeedBarRG02.Create(Self);
  SpeedPanel02.Name := 'SpeedPanel02';
  SpeedPanel02.Parent := Self;
  SpeedPanel02.ShowHint := True;
  SpeedPanel02.Visible := False;
  SpeedPanel02.Caption := '';

  SpeedPanel03 := TActionSpeedBarRG03.Create(Self);
  SpeedPanel03.Name := 'SpeedPanel03';
  SpeedPanel03.Parent := Self;
  SpeedPanel03.ShowHint := True;
  SpeedPanel03.Visible := False;
  SpeedPanel03.Caption := '';

  SpeedPanel04 := TActionSpeedBarRG04.Create(Self);
  SpeedPanel04.Name := 'SpeedPanel04';
  SpeedPanel04.Parent := Self;
  SpeedPanel04.ShowHint := True;
  SpeedPanel04.Visible := False;
  SpeedPanel04.Caption := '';

  SpeedPanel := SpeedPanel03;
  SpeedPanel.Visible := True;

  ParamListbox := TListbox.Create(Self);
  ParamListbox.Name := 'ParamListbox';
  ParamListbox.Parent := Self;

  ReportListbox := TListbox.Create(Self);
  ReportListbox.Name := 'ReportListbox';
  ReportListbox.Parent := Self;

  ComponentsCreated := True;
end;

procedure TFormMain.ToggleSpeedPanel;
begin
  if SpeedPanel = SpeedPanel01 then
    SwapSpeedPanel(RotaForm.Current)
  else
    SwapSpeedPanel(0);
end;

procedure TFormMain.SwapSpeedPanel(Value: Integer);
begin
  SpeedPanel.Visible := False;

    case Value of
      1: SpeedPanel := SpeedPanel03;
      2: SpeedPanel := SpeedPanel04;
      3: SpeedPanel := SpeedPanel01;
    else
      SpeedPanel := SpeedPanel01;
    end;

  SpeedPanel.Width := ClientWidth - 3 * Raster - Margin;
  SpeedPanel.Visible := True;
  SpeedPanel.UpdateLayout;;
  SpeedPanel.DarkMode := MainVar.ColorScheme.IsDark;
  SpeedPanel.UpdateColor;
end;

procedure TFormMain.LayoutSpeedPanel(SP: TActionSpeedBar);
begin
  SP.Anchors := [];
  SP.Left := 2 * Raster + Margin;
  SP.Top := Raster + Margin;
  SP.Width := ClientWidth - 3 * Raster - 2 * Margin;
  SP.Height := SpeedPanelHeight;
  SP.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight];
  SP.UpdateLayout;
end;

procedure TFormMain.LayoutComponents;
begin
  if not ComponentsCreated then
    Exit;

  { ClientWidth and ClientHeight may still be at DesignTime Values, }
  { when called earlier than FormShow. }
  { Then it only 'works' if these values are big enough, }
  { so that computed values for Height and Width are > 0 }

  LayoutSpeedPanel(SpeedPanel01);
  LayoutSpeedPanel(SpeedPanel02);
  LayoutSpeedPanel(SpeedPanel03);
  LayoutSpeedPanel(SpeedPanel04);

  TrimmText.Left := Raster + Margin;
  TrimmText.Top := 2 * Raster + Margin;
  TrimmText.Width := ListboxWidth;
  TrimmText.Height := Round(190 * FScale);

  ParamListbox.Left := TrimmText.Left;
  ParamListbox.Top := TrimmText.Top + TrimmText.Height + Margin;
  ParamListbox.Width := ListboxWidth;
  ParamListbox.Height := Round(260 * FScale);

  ReportListbox.Left := ParamListbox.Left;
  ReportListbox.Top := ParamListbox.Top + ParamListbox.Height + Margin;
  ReportListbox.Width := ParamListbox.Width;
  ReportListbox.Height := ClientHeight - ReportListbox.Top - Raster - Margin;
  ReportListbox.Anchors := ReportListbox.Anchors + [TAnchorKind.akBottom];

  FocusContainer.Left := TrimmText.Left + TrimmText.Width + Margin;
  FocusContainer.Top := TrimmText.Top;
  FocusContainer.Width := Round(40 * FScale);
  FocusContainer.Height := Round(40 * FScale);

  HintContainer.Left := FocusContainer.Left + FocusContainer.Width + Margin;
  HintContainer.Top := TrimmText.Top;
  HintContainer.Width := ReportMemoWidth - FocusContainer.Width - Margin;
  HintContainer.Height := Round(40 * FScale);

  HintText.Left := Round(10 * FScale);
  HintText.Top := Round(10 * FScale);

  ReportText.Left := TrimmText.Left + TrimmText.Width + Margin;
  ReportText.Top := HintContainer.Top + HintContainer.Height + Margin;
  ReportText.Height := ClientHeight - ReportText.Top - Raster - Margin;
  ReportText.Width := ReportMemoWidth;
  ReportText.Anchors := ReportText.Anchors + [TAnchorKind.akBottom];
  ReportText.WordWrap := False;

  TextPositionX := ReportText.Left;
  TextPositionY := ReportText.Top;

  Image.Left := ReportText.Left + ReportText.Width + Margin;
  Image.Top := 2 * Raster + Margin;
  Image.Width := ClientWidth - Image.Left - Raster - Margin;
  Image.Height := ClientHeight - Image.Top - Raster - Margin;
  Image.Anchors := Image.Anchors + [TAnchorKind.akRight, TAnchorKind.akBottom];
  ImagePositionX := Image.Left;
  ImagePositionY := Image.Top;

  SpeedPanel.Width := ClientWidth - 3 * Raster - Margin;
end;

procedure TFormMain.LineColorBtnClick(Sender: TObject);
begin
  RotaForm.WantLineColors := not RotaForm.WantLineColors;
  RotaForm.Draw;
end;

procedure TFormMain.HandleSegment(fa: Integer);
var
  b: Boolean;
begin
  b := RotaForm.GetChecked(fa);
  b := not b;
  RotaForm.SetChecked(fa, b);

  RotaForm.Draw;
end;

procedure TFormMain.SeiteBtnClick(Sender: TObject);
begin
  RotaForm.ViewPoint := vpSeite;
end;

procedure TFormMain.AchternBtnClick(Sender: TObject);
begin
  RotaForm.ViewPoint := vpAchtern;
end;

procedure TFormMain.TopBtnClick(Sender: TObject);
begin
  RotaForm.ViewPoint := vpTop;
end;

procedure TFormMain.NullBtnClick(Sender: TObject);
begin
  RotaForm.ViewPoint := vp3D;
end;

procedure TFormMain.ChartImageBtnClick(Sender: TObject);
begin
  ChartControl.Visible := not ChartControl.Visible;
  if ChartControl.Visible then
    ChartControl.BringToFront;

  ChartImage.Visible := ChartControl.Visible;

  if ChartControl.Visible and ChartImage.Visible then
    UpdateChartGraph;
  Main.FederTextRepaint;;
end;

procedure TFormMain.SalingImageBtnClick(Sender: TObject);
begin
  SalingImage.Visible := not SalingImage.Visible;
  if SalingImage.Visible then
    SalingImage.BringToFront;
  if SalingImage.Visible then
    UpdateSalingGraph;
  Main.FederTextRepaint;;
end;

procedure TFormMain.ControllerImageBtnClick(Sender: TObject);
begin
  ControllerImage.Visible := not ControllerImage.Visible;
  if ControllerImage.Visible then
    ControllerImage.BringToFront;
  if ControllerImage.Visible then
    UpdateControllerGraph;
  Main.FederTextRepaint;;
end;

procedure TFormMain.InitSalingGraph;
begin
  SalingImage := TImage.Create(Self);
  SalingImage.Name := 'SalingImage';
  SalingImage.Parent := Self;
  SalingImage.Visible := False;

  SalingGraph := TSalingGraph.Create;
  SalingGraph.BackgroundColor := TColors.Antiquewhite;
  SalingGraph.ImageOpacity := 0.2;
  SalingGraph.SalingA := 850;
  SalingGraph.SalingH := 120;
  SalingGraph.SalingL := 479;
  SalingGraph.SalingHOffset := 37;
  SalingGraph.Image := SalingImage;
  UpdateSalingGraph;
end;

procedure TFormMain.UpdateSalingGraph;
begin
  if IsUp and SalingImage.Visible then
  begin
    SalingGraph.SalingA := Round(Main.ParamValue[fpSalingA]);
    SalingGraph.SalingH := Round(Main.ParamValue[fpSalingH]);
    SalingGraph.SalingL := Round(Main.ParamValue[fpSalingL]);
    SalingGraph.Draw(TFigure.dtSalingDetail);
  end;
end;

procedure TFormMain.InitControllerGraph;
begin
  ControllerImage := TImage.Create(Self);
  ControllerImage.Name := 'ControllerImage';
  ControllerImage.Parent := Self;
  ControllerImage.Visible := False;

  ControllerGraph := TSalingGraph.Create;
  ControllerGraph.BackgroundColor := MainVar.ColorScheme.claBackground;
  ControllerGraph.ImageOpacity := 0.2;

  ControllerGraph.ControllerTyp := TControllerTyp.ctDruck;
  ControllerGraph.EdgePos := 25;
  ControllerGraph.ControllerPos := 80;
  ControllerGraph.ParamXE := -20;
  ControllerGraph.ParamXE0 := 110;

  ControllerGraph.Image := ControllerImage;
  UpdateControllerGraph;
end;

procedure TFormMain.UpdateControllerGraph;
begin
  if IsUp and ControllerImage.Visible then
  begin
    ControllerGraph.ControllerTyp := Rigg.ControllerTyp;
    ControllerGraph.ControllerPos := Round(Main.ParamValue[fpController]);
    ControllerGraph.ParamXE := Rigg.MastPositionE;
    ControllerGraph.ParamXE0 := Round(Rigg.GetPoint3D(ooE0).X - Rigg.GetPoint3D(ooD0).X);
    ControllerGraph.EdgePos := Round(Rigg.RggFA.Find(fpController).Min);

    ControllerGraph.Draw(TFigure.dtController);
  end;
end;

procedure TFormMain.InitChartGraph;
begin
  ChartControl := TWinControl.Create(Self);
  ChartControl.Name := 'ChartControl';
  ChartControl.Parent := Self;
  ChartControl.Visible := False;

  ChartImage := TImage.Create(Self);
  ChartImage.Name := 'ChartImage';
  ChartImage.Parent := ChartControl;
  ChartImage.Visible := False;

  ChartGraph := TChartGraph.Create(Rigg);
  ChartGraph.Image := ChartImage;

  UpdateChartGraph;
end;

procedure TFormMain.UpdateChartGraph;
begin
  if IsUp and ChartControl.Visible and ChartImage.Visible then
  begin
    ChartGraph.SuperCalc;
  end;
end;

procedure TFormMain.LayoutImages;
var
  PosX: Integer;
  PosY: Integer;
begin
  if not ComponentsCreated then
    Exit;

  PosX := ClientWidth - (Raster + Margin + ControllerImage.Width);
  PosY := SpeedPanel.Top + SpeedPanel.Height + Margin;

  ControllerImage.Left := PosX;
  ControllerImage.Top := PosY;
  ControllerImage.Anchors := [TAnchorKind.akTop, TAnchorKind.akRight];

  if Screen.Height > FScale * 1000 then
    PosY := PosY + ControllerImage.Height;

  SalingImage.Left := PosX;
  SalingImage.Top := PosY + ControllerImage.Height + Margin;
  SalingImage.Anchors := [TAnchorKind.akTop, TAnchorKind.akRight];

  ChartControl.Left := Round(ReportText.Left + 200 * FScale);
  ChartControl.Top := Round(ReportText.Top + 20 * FScale);
  ChartControl.Width := Round(ChartImage.Width);
  ChartControl.Height := Round(ChartImage.Height);
end;

procedure TFormMain.SetViewPoint(const Value: TViewPoint);
begin
  FViewPoint := Value;
  RotaForm.ViewPoint := Value;
end;

procedure TFormMain.ReportListboxChange(Sender: TObject);
var
  ii: Integer;
begin
  RL.Clear;
  ii := ReportListbox.ItemIndex;
  if (ii >= 0) and (ii <= Integer(High(TRggReport)))then
  begin
    ShowingHelp := False;
    ReportText.Visible := True;
    ReportManager.CurrentIndex := ii;
    UpdateReport;
    Main.FederTextCheckState;
  end;
end;

procedure TFormMain.ParamListboxChange(Sender: TObject);
begin
  if ParamListbox.ItemIndex <> -1 then
    Main.Param := Main.Text2Param(ParamListbox.Items[ParamListbox.ItemIndex]);
  ShowTrimm;
  UpdateControllerGraph;
  Main.FederTextCheckState;
end;

procedure TFormMain.InitParamListbox;
var
  rm: TMain;
  LI: TStrings;
  fp: TFederParam;
  s: string;

  procedure Add(fp: TFederParam);
  begin
    LI.AddObject(rm.Param2Text(fp), TObject(fp));
  end;
begin
  rm := Main;
  LI := ParamListbox.Items;
  LI.Clear;

  { Add a subset of available Params }
  Add(fpController);
  Add(fpWinkel);
  Add(fpVorstag);
  Add(fpWante);
  Add(fpWoben);
  Add(fpSalingH);
  Add(fpSalingA);
  Add(fpSalingL);
  Add(fpSalingW);
  Add(fpMastfallF0C);
  Add(fpMastfallF0F);
  Add(fpBiegung);
  Add(fpD0X);

  { Init ItemIndex }
  fp := rm.Param;
  s := rm.Param2Text(fp);
  ParamListbox.ItemIndex := LI.IndexOf(s);
end;

procedure TFormMain.ShowTrimmData;
begin
  RL.BeginUpdate;
  try
    RL.Clear;
    Main.CurrentTrimm.WantAll := MainVar.AllProps;
    Main.CurrentTrimm.SaveTrimmItem(RL);
    Main.CurrentTrimm.WantAll := False;
    if ReportLabel <> nil then
    begin
      ReportLabel.Caption := 'Trimm' + IntToStr(Main.Trimm);
    end;
  finally
    RL.EndUpdate;
  end;
end;

procedure TFormMain.ShowTrimm;
begin
  if TL <> nil then
  begin
    Main.UpdateTrimmText(TL);
    TrimmText.Text := TL.Text;
    UpdateFederText;
  end;
  UpdateReport;
end;

procedure TFormMain.SofortBtnClick(Sender: TObject);
begin
  Main.SofortBerechnen := not Main.SofortBerechnen;
  if Sender <> nil then
    Main.FederTextCheckState;
  UpdateReport;
end;

procedure TFormMain.GrauBtnClick(Sender: TObject);
begin
  Main.BtnGrauDown := not Main.BtnGrauDown;
end;

procedure TFormMain.BlauBtnClick(Sender: TObject);
begin
  Main.BtnBlauDown := not Main.BtnBlauDown;
end;

procedure TFormMain.MemoryBtnClick(Sender: TObject);
begin
  Main.MemoryBtnClick;
  UpdateReport;
end;

procedure TFormMain.MemoryRecallBtnClick(Sender: TObject);
begin
  Main.MemoryRecallBtnClick;
  ShowTrimm;
end;

procedure TFormMain.MultiBtnClick(Sender: TObject);
begin
  RotaForm.WantOverlayedRiggs := not RotaForm.WantOverlayedRiggs;
  Main.Draw;
end;

procedure TFormMain.BogenBtnClick(Sender: TObject);
begin
  Main.Bogen := not Main.Bogen;
  if Sender <> nil then
    Main.FederTextCheckState;
end;

procedure TFormMain.KoppelBtnClick(Sender: TObject);
begin
  Main.Koppel := not Main.Koppel;
  if Sender <> nil then
    Main.FederTextCheckState;
end;

procedure TFormMain.HullBtnClick(Sender: TObject);
begin
  Main.HullVisible := not Main.HullVisible;
  if Sender <> nil then
    Main.FederTextCheckState;
end;

function TFormMain.GetChecked(fa: Integer): Boolean;
begin
  result := false;
  if not IsUp then
    Exit;

  case fa of
    faToggleSandboxed: result := MainVar.IsSandboxed;
    faToggleAllProps: result := MainVar.AllProps;
    faToggleAllTags: result := MainVar.AllTags;
    faToggleButtonSize: result := SpeedPanel.BigMode;

    faToggleHelp: result := ShowingHelp;
    faToggleReport: result := ReportText.Visible;
    faToggleButtonReport: result := WantButtonReport;
    faReportNone..faReportReadme: result := ReportManager.GetChecked(fa);
    faToggleSegmentF..faToggleSegmentA: result := RotaForm.GetChecked(fa);

    faToggleLineColor: result := RotaForm.WantLineColors;
    faToggleShowLegend: result := RotaForm.LegendItemChecked;

    faToggleUseDisplayList: result := RotaForm.UseDisplayList;
    faToggleUseQuickSort: result := RotaForm.UseQuickSort;
    faToggleSortedRota:result := RotaForm.GetChecked(fa);

    faRggBogen: result := Main.Bogen;
    faRggKoppel: result := Main.Koppel;

    faSofortBtn: result := Main.SofortBerechnen;
    faGrauBtn: result := Main.BtnGrauDown;
    faBlauBtn: result := Main.BtnBlauDown;
    faMemoryBtn: result := False;
    faMultiBtn: result := RotaForm.WantOverlayedRiggs;

    faChartRect..faChartReset: result := ChartGraph.GetChecked(fa);
    faToggleChartGraph: result := ChartControl.Visible;
    faToggleSalingGraph: result := SalingImage.Visible;
    faToggleControllerGraph: result := ControllerImage.Visible;
    faToggleMatrixText: result := RotaForm.MatrixItemChecked;

    faRotaForm1: result := RotaForm.Current = 1;
    faRotaForm2: result := RotaForm.Current = 2;
    faRotaForm3: result := RotaForm.Current = 3;
  end;
end;

procedure TFormMain.CheckFormBounds(AForm: TForm);
begin
  if Screen.Height <= 768 then
    AForm.Top := 0;
  if Screen.Width <= 768 then
    AForm.Left := 0;
  if AForm.Left + AForm.Width > Screen.Width then
    AForm.Width := Screen.Width - AForm.Left - 20;
  if AForm.Top + AForm.Height > Screen.Height then
    AForm.Height := Screen.Width - AForm.Top - 20;
end;

procedure TFormMain.InitScreenPos;
begin
  if (Screen.Width >= FScale * 1920) and (Screen.Height >= FScale * 1024) then
  begin
    { Tested on normal HD screen }
    Left := Round(100 * FScale);
    Top := Round(30 * FScale);
    Width := Round(1700 * FScale);
    Height := Round(960 * FScale);
    ReportMemoWidth := Round(480 * FScale);
  end
  else
  begin
    { Tested on Microsoft Surface Tablet }
    Left := Round(20 * FScale);
    Top := Round(30 * FScale);
    Width := Round(1336 * FScale);
    Height := Round(800 * FScale);
    ReportMemoWidth := Round(320 * FScale);
  end;
end;

procedure TFormMain.MemoBtnClick(Sender: TObject);
begin
  if not Assigned(FormMemo) then
  begin
    FormMemo := TFormMemo.Create(nil);
    FormMemo.Parent := nil;
    FormMemo.Memo.Lines.Clear;
    CheckFormBounds(FormMemo);
  end;
  FormMemo.Visible := True;
end;

procedure TFormMain.ActionsBtnClick(Sender: TObject);
begin
  if not Assigned(FormAction) then
  begin
    FormAction := TFormAction.Create(nil);
    FormAction.Parent := nil;
    CheckFormBounds(FormAction);
  end;
  FormAction.Visible := True;
end;

procedure TFormMain.DrawingsBtnClick(Sender: TObject);
begin
  if not Assigned(FormDrawing) then
  begin
    FormDrawing := TFormDrawing.Create(nil);
    FormDrawing.Parent := nil;
    CheckFormBounds(FormDrawing);
  end;
  FormDrawing.Visible := True;
end;

procedure TFormMain.ConfigBtnClick(Sender: TObject);
begin
  if FormConfig = nil then
  begin
    FormConfig := TFormConfig.Create(Application);
    FormConfig.Parent := nil;
    FormConfig.Init(Rigg);
  end;

  { Istwerte in GSB aktualisieren für aktuelle Werte in Optionform }
  Rigg.UpdateGSB;
  FormConfig.ShowModal;
  if FormConfig.ModalResult = mrOK then
  begin
    Rigg.UpdateGlieder; { neue GSB Werte --> neue Integerwerte }
    Rigg.Reset; { neue Integerwerte --> neue Gleitkommawerte }
    Main.UpdateGetriebe;
    UpdateReport;
  end;
end;

procedure TFormMain.TrimmTabBtnClick(Sender: TObject);
begin
  if not Assigned(FormTrimmTab) then
  begin
    FormTrimmTab := TFormTrimmTab.Create(Application);
    FormTrimmTab.Parent := nil;
    FormTrimmTab.Init(Rigg);
  end;

  FormTrimmTab.ShowModal;
  if FormTrimmTab.ModalResult = mrOK then
  begin
    UpdateReport;
  end;
end;

procedure TFormMain.DestroyForms;
begin
  if FormAction <> nil then
  begin
    FormAction.Free;
    FormAction := nil;
  end;
  if FormDrawing <> nil then
  begin
    FormDrawing.Free;
    FormAction := nil;
  end;
  if FormMemo <> nil then
  begin
    FormMemo.Free;
    FormMemo := nil;
  end;
  if FormDiagramC <> nil then
  begin
    FormDiagramC.Free;
    FormDiagramC := nil;
  end;

  { Forms owned by Application not freed here. }
  { FormSplash is disposing of itself. }
end;

procedure TFormMain.InitSpeedButtons;
begin
  if SpeedPanel01 <> nil then
    SpeedPanel01.InitSpeedButtons;

  if SpeedPanel02 <> nil then
    SpeedPanel02.InitSpeedButtons;

  if SpeedPanel03 <> nil then
    SpeedPanel03.InitSpeedButtons;

  if SpeedPanel04 <> nil then
    SpeedPanel04.InitSpeedButtons;
end;

procedure TFormMain.UpdateColorScheme;
begin
  if not ComponentsCreated then
    Exit;

  RotaForm.BackgroundColor := MainVar.ColorScheme.claBackground;

  ControllerGraph.BackgroundColor := MainVar.ColorScheme.claBackground;
  UpdateControllerGraph;

  SalingGraph.BackgroundColor := MainVar.ColorScheme.claBackground;
  UpdateSalingGraph;

  RotaForm.DarkMode := MainVar.ColorScheme.IsDark;
end;

procedure TFormMain.SuperSimpleBtnClick(Sender: TObject);
begin
  RotaForm.UseDisplayList := False;
  RotaForm.WantOverlayedRiggs := False;
  Main.GraphRadio := gSimple;
end;

procedure TFormMain.SuperNormalBtnClick(Sender: TObject);
begin
  RotaForm.UseDisplayList := False;
  RotaForm.WantOverlayedRiggs := False;
  Main.GraphRadio := gNormal;
end;

procedure TFormMain.SuperGrauBtnClick(Sender: TObject);
begin
  RotaForm.UseDisplayList := False;
  RotaForm.WantOverlayedRiggs := True;
  Main.GraphRadio := gGrau;
end;

procedure TFormMain.SuperBlauBtnClick(Sender: TObject);
begin
  RotaForm.UseDisplayList := False;
  RotaForm.WantOverlayedRiggs := True;
  Main.GraphRadio := gBlau;
end;

procedure TFormMain.SuperMultiBtnClick(Sender: TObject);
begin
  RotaForm.UseDisplayList := False;
  RotaForm.WantOverlayedRiggs := True;
  Main.GraphRadio := gMulti;
end;

procedure TFormMain.SuperDisplayBtnClick(Sender: TObject);
begin
  RotaForm.UseDisplayList := True;
  RotaForm.WantOverlayedRiggs := False;
  RotaForm.UseQuickSort := False;
  Main.GraphRadio := gDisplay;
end;

procedure TFormMain.SuperQuickBtnClick(Sender: TObject);
begin
  RotaForm.UseDisplayList := True;
  RotaForm.WantOverlayedRiggs := False;
  RotaForm.UseQuickSort := True;
  Main.GraphRadio := gQuick;
end;

procedure TFormMain.UpdateParent;
var
  ft: TWinControl;
begin
  ft := Main.FederText;
  Image.Parent := ft;
  SalingImage.Parent := ft;
  ControllerImage.Parent := ft;
  ReportText.Parent := ft;
  ParamListbox.Parent := ft;
  ReportListbox.Parent := ft;
  TrimmText.Parent := ft;
  FocusContainer.Parent := ft;
  HintContainer.Parent := ft;
  SpeedPanel01.Parent := ft;
  SpeedPanel02.Parent := ft;
  SpeedPanel03.Parent := ft;
  SpeedPanel04.Parent := ft;
end;

procedure TFormMain.InitZOrderInfo;
var
  i: Integer;
  c: TControl;
begin
  for i := 0 to Self.ControlCount-1 do
  begin
    c := Controls[i];
    HL.Add(Format('%2d - %s: %s', [i, c.Name, c.ClassName]));
  end;
end;

procedure TFormMain.InitDebugInfo;
begin
  HL.Add('Window-Info:');
  HL.Add(Format('  Initial-Client-W-H = (%d, %d)', [ClientWidth, ClientHeight]));
  HL.Add(Format('  Handle.Scale = %.1f', [MainVar.Scale]));
end;

procedure TFormMain.ShowHelpText(fa: Integer);
begin
  HL.Clear;

  case fa of
    faShowHelpText: Main.FederBinding.InitSplashText(HL);
    faShowInfoText: Main.FederBinding.InitInfoText(HL);
    faShowNormalKeyInfo: Main.FederBinding.InitNormalKeyInfo(HL);
    faShowSpecialKeyInfo: Main.FederBinding.InitSpecialKeyInfo(HL);
    faShowDebugInfo: InitDebugInfo;
    faShowZOrderInfo: InitZOrderInfo;
  end;

  ShowingHelp := True;
  ReportText.Text := HL.Text;
  ReportText.Visible := True;
end;

procedure TFormMain.SwapRota(Value: Integer);
begin
  RotaForm.SwapRota(Value);
  RotaForm.BackgroundColor := MainVar.ColorScheme.claBackground;
  RotaForm.DarkMode := MainVar.ColorScheme.IsDark;
  SwapSpeedPanel(RotaForm.Current);
end;

procedure TFormMain.DoOnUpdateChart(Sender: TObject);
begin
  if (ChartGraph <> nil) and (Main.Param = fpAPW)  then
  begin
    ChartGraph.APWidth := Round(Main.CurrentValue);
    ChartGraph.UpdateXMinMax;
  end;
end;

procedure TFormMain.UpdateFederText;
begin
  Main.FederTextUpdateCaption;
end;

procedure TFormMain.CenterRotaForm;
begin
  RotaForm.InitPosition(Width, Height, 0, 0);
  if FormShown then
    RotaForm.Draw;
end;

procedure TFormMain.ToggleButtonSize;
begin
  SpeedPanel.ToggleBigMode;
  LayoutComponents;
  CheckSpaceForMemo;
  CheckSpaceForImages;
end;

procedure TFormMain.ToggleAllText;
var
  b: Boolean;
begin
  if not Main.FederText.Visible then
    Exit;

  if Main.FederText = Main.FederText2 then
    Exit;

  if not CanShowMemo then
    Exit;

  b := not ParamListbox.Visible;

  SpeedPanel.Visible := b;
  FocusContainer.Visible := b;
  TrimmText.Visible := b;
  ParamListbox.Visible := b;
  ReportListbox.Visible := b;
  ReportText.Visible := b;
end;

function TFormMain.GetCanShowMemo: Boolean;
begin
  result := True;

  if (ClientWidth < 900 * FScale) then
    result := False;

  if (ClientHeight < 700 * FScale) then
    result := False;

  if Main.IsPhone then
    result := False;
end;

procedure TFormMain.ShowDiagramE;
begin
  if not Assigned(FormDiagramE) then
  begin
    FormDiagramE := TFormDiagramE.Create(Application);
  end;
  FormDiagramE.Show;
end;

procedure TFormMain.ShowDiagramQ;
begin
  if not Assigned(FormDiagramQ) then
  begin
    FormDiagramQ := TFormDiagramQ.Create(Application);
  end;
  FormDiagramQ.Show;
end;

procedure TFormMain.ShowDiagramC;
begin
  if not Assigned(FormDiagramC) then
  begin
    FormDiagramC := TFormDiagramC.Create(nil);
    FormDiagramC.Parent := nil;
    FormDiagramC.ChartModel := ChartGraph;
    ChartGraph.OnActionHandled := FormDiagramC.UpdateUI;

    if not ChartControl.Visible then
    begin
      Main.FederText.ActionPage := 9;
      ChartImageBtnClick(nil);
    end;
  end;

  FormDiagramC.Visible := True;
end;

procedure TFormMain.ShowFormKreis;
begin
  if not Assigned(KreisForm) then
  begin
    KreisForm := TKreisForm.Create(Application);
  end;
  KreisForm.Show;
end;

{$ifdef WantMenu}
procedure TFormMain.PopulateMenu;
begin
  if Assigned(MainMenu) and Assigned(Main) then
  begin
    FederMenu.InitMainMenu(MainMenu);
  end;
end;
{$endif}

end.
