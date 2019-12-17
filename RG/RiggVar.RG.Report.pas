﻿unit RiggVar.RG.Report;

interface

uses
  System.Classes,
  System.Generics.Collections,
  Vcl.StdCtrls,
  RiggVar.RG.Def,
  IoTypes;

type
  TRggReport = (
    rgLog,
    rgJson,
    rgData,
    rgTrimmText,
    rgDataText,
    rgDiffText,
    rgAusgabeRL,
    rgAusgabeRP,
    rgAusgabeRLE,
    rgAusgabeRPE,
    rgAusgabeDiffL,
    rgAusgabeDiffP,
    rgXML,
    rgDebugReport,
    rgReadme,
    rgNone
  );

  TRggReportManager = class
  private
    FMemo: TMemo;
    ML: TStrings;
    RiggReport: TRiggReport;
    RD: TDictionary<Integer, TRggReport>;
    rs: set of TRggReport;
    FCurrentIndex: Integer;
    FCurrentReport: TRggReport;
    FXmlAllTags: Boolean;
    procedure InitRD;
    procedure SetCurrentIndex(const Value: Integer);
    procedure SetXmlAllTags(const Value: Boolean);
  public
    constructor Create(Memo: TMemo);
    destructor Destroy; override;
    procedure InitLB(LB: TStrings);

    procedure ShowCurrentReport;
    function GetReportCaption(r: TRggReport): string;
    function GetCurrentCaption: string;
    property CurrentIndex: Integer read FCurrentIndex write SetCurrentIndex;
    property CurrentReport: TRggReport read FCurrentReport;
    property XmlAllTags: Boolean read FXmlAllTags write SetXmlAllTags;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.Messages,
  RiggVar.App.Main;

constructor TRggReportManager.Create(Memo: TMemo);
begin
  FMemo := Memo;
  ML := Memo.Lines;
  RiggReport := TRiggReport.Create;
  RD := TDictionary<Integer, TRggReport>.Create;
  InitRD;
end;

destructor TRggReportManager.Destroy;
begin
  ML := nil; // not owned
  RD.Free;
  RiggReport.Free;
  inherited;
end;

function TRggReportManager.GetCurrentCaption: string;
begin
  result := GetReportCaption(CurrentReport);
end;

function TRggReportManager.GetReportCaption(r: TRggReport): string;
begin
  case r of
    rgLog: result := 'Log';
    rgJson: result := 'WriteJson'; // 'Main.RggData.WriteJson'
    rgData: result := 'WriteReport'; // 'Main.RggData.WriteReport'
    rgTrimmText: result := 'Trimm Text';
    rgDataText: result := 'Data Text';
    rgDiffText: result := 'Diff Text';
    rgAusgabeRL: result := 'Ausgabe rL';
    rgAusgabeRP: result := 'Ausgabe rP';
    rgAusgabeRLE: result := 'Ausgabe rLE';
    rgAusgabeRPE: result := 'Ausgabe rPE';
    rgAusgabeDiffL: result := 'Ausgabe Diff L';
    rgAusgabeDiffP: result := 'Ausgabe Diff P';
    rgXML: result := 'Write XML';
    rgDebugReport: result := 'Debug Report';
    rgReadme: result := 'Readme';
    rgNone: result := 'Do Nothing';
    else
      result := 'Unknown';
  end;
end;

procedure TRggReportManager.SetCurrentIndex(const Value: Integer);
var
  r: TRggReport;
begin
//  FCurrentReport := RD.Items[Value];
  if RD.TryGetValue(Value, r) then
  begin
    FCurrentIndex := Value;
    FCurrentReport := r;
  end;
end;

procedure TRggReportManager.SetXmlAllTags(const Value: Boolean);
begin
  FXmlAllTags := Value;
end;

procedure TRggReportManager.ShowCurrentReport;
var
  MemoPosY: LongInt;
begin
  ML.BeginUpdate;
  try
    MemoPosY := SendMessage(FMemo.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
    ML.Clear;
    case CurrentReport of
      rgNone: ;
      rgReadme:
      begin
        ML.Add('Use the Scroll Wheel of the Mouse!!!');
        ML.Add('');
        ML.Add('Scroll Wheel will scroll the text if text is long.');
        ML.Add('Shift Wheel will change current param value (small step)');
        ML.Add('Ctrl Wheel will change current param value (big step)');
        ML.Add('The "mouse" must be over this window (Form Text).');
        ML.Add('');
        ML.Add('- Form Text was added on top of the "old" application.');
        ML.Add('- In Xml Report current text scroll position is maintained.');
        ML.Add('- Try out AutoCalc mode (On) while using shift wheel.');
      end;
      rgLog: ML.Text := Main.Logger.TL.Text;
      rgJson: Main.RggData.WriteJSon(ML);
      rgData: Main.RggData.WriteReport(ML);
      rgAusgabeRL:
      begin
        RiggReport.ML.Clear;
        RiggReport.AusgabeRL(Main.RggMain.Rigg.rL);
        ML.Assign(RiggReport.ML);
      end;
      rgAusgabeRP:
      begin
        RiggReport.ML.Clear;
        RiggReport.AusgabeRP(Main.RggMain.Rigg.rP);
        ML.Assign(RiggReport.ML);
      end;
      rgAusgabeRLE:
      begin
        RiggReport.ML.Clear;
        RiggReport.AusgabeRLE(Main.RggMain.Rigg.rLE);
        ML.Assign(RiggReport.ML);
      end;
      rgAusgabeRPE:
      begin
        RiggReport.ML.Clear;
        RiggReport.AusgabeRPE(Main.RggMain.Rigg.rPE);
        ML.Assign(RiggReport.ML);
      end;
      rgAusgabeDiffL:
      begin
        RiggReport.ML.Clear;
        RiggReport.AusgabeDiffL(Main.RggMain.Rigg.rL, Main.RggMain.Rigg.rLE);
        ML.Assign(RiggReport.ML);
      end;
      rgAusgabeDiffP:
      begin
        RiggReport.ML.Clear;
        RiggReport.AusgabeDiffP(Main.RggMain.Rigg.rP, Main.RggMain.Rigg.rPE);
        ML.Assign(RiggReport.ML);
      end;
      rgXML:
      begin
        Main.RggMain.Rigg.WriteXml(ML, XmlAllTags);
        SendMessage(FMemo.Handle, EM_LINESCROLL, 0, MemoPosY);
      end;
      rgDiffText: Main.RggMain.UpdateDiffText(ML);
      rgDataText: Main.RggMain.UpdateDataText(ML);
      rgTrimmText: Main.RggMain.UpdateTrimmText(ML);
      rgDebugReport:
      begin
        Main.DoCleanReport;
        ML.Text := Main.Logger.TL.Text;
      end;
    end;
  finally
    ML.EndUpdate;
  end;

  //ReportLabel.Caption := GetReportCaption(CurrentReport)
end;

procedure TRggReportManager.InitRD;
var
  i: Integer;
  r: TRggReport;
begin
  for r := Low(TRggReport) to High(TRggReport) do
    Include(rs, r);

  Exclude(rs, rgTrimmText);
  Exclude(rs, rgAusgabeDiffL);
  Exclude(rs, rgAusgabeDiffP);
  Exclude(rs, rgDebugReport);

//    rgLog,
//    rgJson,
//    rgData,
//    rgTrimmText,
//    rgDataText,
//    rgDiffText,
//    rgAusgabeRL,
//    rgAusgabeRP,
//    rgAusgabeRLE,
//    rgAusgabeRPE,
//    rgAusgabeDiffL,
//    rgAusgabeDiffP,
//    rgXML,
//    rgDebugReport

  i := 0;
  for r in rs do
  begin
    RD.Add(i, r);
    Inc(i);
  end;
end;

procedure TRggReportManager.InitLB(LB: TStrings);
var
  r: TRggReport;
begin
  for r in rs do
    LB.Add(GetReportCaption(r));
end;

end.
