enum 50100 "ICR Recharge Status"
{
    Extensible = true;

    value(0; Draft) { Caption = 'Draft'; }
    value(1; Validated) { Caption = 'Validated'; }
    value(2; "Pending Approval") { Caption = 'Pending Approval'; }
    value(3; Approved) { Caption = 'Approved'; }
    value(4; Rejected) { Caption = 'Rejected'; }
    value(5; Posted) { Caption = 'Posted'; }
    value(6; Reversed) { Caption = 'Reversed'; }
    value(7; Closed) { Caption = 'Closed'; }
}

enum 50101 "ICR Allocation Basis"
{
    Extensible = true;

    value(0; "Fixed Percentage") { Caption = 'Fixed Percentage'; }
    value(1; Amount) { Caption = 'Amount'; }
    value(2; Dimension) { Caption = 'Dimension'; }
    value(3; Driver) { Caption = 'Driver'; }
    value(4; Manual) { Caption = 'Manual'; }
}

enum 50102 "ICR Posting Method"
{
    Extensible = true;

    value(0; Journal) { Caption = 'Journal'; }
    value(1; Document) { Caption = 'Document'; }
}

enum 50103 "ICR Currency Rule"
{
    Extensible = true;

    value(0; "Source Currency") { Caption = 'Source Currency'; }
    value(1; "Target Currency") { Caption = 'Target Currency'; }
    value(2; "Exchange Rate") { Caption = 'Exchange Rate'; }
}

enum 50104 "ICR Partner Response Status"
{
    Extensible = true;

    value(0; Pending) { Caption = 'Pending'; }
    value(1; Sent) { Caption = 'Sent'; }
    value(2; Accepted) { Caption = 'Accepted'; }
    value(3; Rejected) { Caption = 'Rejected'; }
    value(4; "Correction Required") { Caption = 'Correction Required'; }
    value(5; Corrected) { Caption = 'Corrected'; }
    value(6; Reversed) { Caption = 'Reversed'; }
    value(7; Closed) { Caption = 'Closed'; }
    value(8; Failed) { Caption = 'Failed'; }
}

enum 50105 "ICR Correction Type"
{
    Extensible = true;

    value(0; None) { Caption = 'None'; }
    value(1; Reversal) { Caption = 'Reversal'; }
    value(2; Delta) { Caption = 'Delta'; }
    value(3; Correction) { Caption = 'Correction'; }
}

enum 50106 "ICR Exception Severity"
{
    Extensible = true;

    value(0; Info) { Caption = 'Info'; }
    value(1; Warning) { Caption = 'Warning'; }
    value(2; Error) { Caption = 'Error'; }
    value(3; Blocking) { Caption = 'Blocking'; }
}

enum 50107 "ICR Processing Status"
{
    Extensible = true;

    value(0; Pending) { Caption = 'Pending'; }
    value(1; Running) { Caption = 'Running'; }
    value(2; Completed) { Caption = 'Completed'; }
    value(3; Failed) { Caption = 'Failed'; }
    value(4; Retried) { Caption = 'Retried'; }
    value(5; Skipped) { Caption = 'Skipped'; }
}
