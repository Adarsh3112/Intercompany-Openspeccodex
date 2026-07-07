permissionset 50100 "ICR ADMIN"
{
    Assignable = true;
    Caption = 'Intercompany Recharge Admin';
    Permissions =
        tabledata "ICR Recharge Setup" = RIMD,
        tabledata "ICR Partner Rule" = RIMD,
        tabledata "ICR Dimension Rule" = RIMD,
        tabledata "ICR Driver Value" = RIMD,
        tabledata "ICR Recharge Request" = RIMD,
        tabledata "ICR Recharge Source Line" = RIMD,
        tabledata "ICR Recharge Allocation Line" = RIMD,
        tabledata "ICR Recharge Posting Link" = RIMD,
        tabledata "ICR Recharge Audit Event" = RIMD,
        tabledata "ICR Recharge Exception" = RIMD,
        tabledata "ICR Approval History" = RIMD,
        tabledata "ICR Processing Unit" = RIMD,
        tabledata "ICR Reconciliation Result" = RIMD,
        table "ICR Recharge Setup" = X,
        table "ICR Partner Rule" = X,
        table "ICR Dimension Rule" = X,
        table "ICR Driver Value" = X,
        table "ICR Recharge Request" = X,
        table "ICR Recharge Source Line" = X,
        table "ICR Recharge Allocation Line" = X,
        table "ICR Recharge Posting Link" = X,
        table "ICR Recharge Audit Event" = X,
        table "ICR Recharge Exception" = X,
        table "ICR Approval History" = X,
        table "ICR Processing Unit" = X,
        table "ICR Reconciliation Result" = X,
        codeunit "ICR Recharge Mgt." = X,
        codeunit "ICR Audit Mgt." = X,
        codeunit "ICR Recharge Self Tests" = X,
        page "ICR Recharge Setup" = X,
        page "ICR Partner Rules" = X,
        page "ICR Dimension Rules" = X,
        page "ICR Recharge Requests" = X,
        page "ICR Recharge Request Card" = X,
        page "ICR Recharge Source Lines" = X,
        page "ICR Recharge Alloc Lines" = X,
        page "ICR Posting Links" = X,
        page "ICR Audit Events" = X,
        page "ICR Exceptions" = X,
        page "ICR Approval History" = X,
        page "ICR Operational Monitor" = X,
        page "ICR Reconciliation Results" = X;
}

permissionset 50101 "ICR ANALYST"
{
    Assignable = true;
    Caption = 'Intercompany Recharge Analyst';
    Permissions =
        tabledata "ICR Recharge Setup" = R,
        tabledata "ICR Partner Rule" = R,
        tabledata "ICR Dimension Rule" = R,
        tabledata "ICR Driver Value" = R,
        tabledata "ICR Recharge Request" = RIM,
        tabledata "ICR Recharge Source Line" = RIM,
        tabledata "ICR Recharge Allocation Line" = RIM,
        tabledata "ICR Recharge Audit Event" = RI,
        tabledata "ICR Recharge Exception" = RI,
        tabledata "ICR Approval History" = R,
        tabledata "ICR Reconciliation Result" = R,
        codeunit "ICR Recharge Mgt." = X,
        page "ICR Recharge Requests" = X,
        page "ICR Recharge Request Card" = X,
        page "ICR Recharge Source Lines" = X,
        page "ICR Recharge Alloc Lines" = X,
        page "ICR Exceptions" = X;
}

permissionset 50102 "ICR MANAGER"
{
    Assignable = true;
    Caption = 'Intercompany Recharge Manager';
    Permissions =
        tabledata "ICR Recharge Setup" = R,
        tabledata "ICR Partner Rule" = RM,
        tabledata "ICR Dimension Rule" = RM,
        tabledata "ICR Recharge Request" = RIM,
        tabledata "ICR Recharge Source Line" = RIM,
        tabledata "ICR Recharge Allocation Line" = RIM,
        tabledata "ICR Recharge Audit Event" = RI,
        tabledata "ICR Recharge Exception" = RIM,
        tabledata "ICR Approval History" = RIM,
        tabledata "ICR Reconciliation Result" = R,
        codeunit "ICR Recharge Mgt." = X,
        page "ICR Partner Rules" = X,
        page "ICR Dimension Rules" = X,
        page "ICR Recharge Requests" = X,
        page "ICR Recharge Request Card" = X,
        page "ICR Approval History" = X,
        page "ICR Exceptions" = X;
}

permissionset 50103 "ICR POSTER"
{
    Assignable = true;
    Caption = 'Intercompany Recharge Poster';
    Permissions =
        tabledata "ICR Recharge Setup" = R,
        tabledata "ICR Partner Rule" = R,
        tabledata "ICR Recharge Request" = RM,
        tabledata "ICR Recharge Source Line" = R,
        tabledata "ICR Recharge Allocation Line" = RM,
        tabledata "ICR Recharge Posting Link" = RIM,
        tabledata "ICR Recharge Audit Event" = RI,
        tabledata "ICR Recharge Exception" = RIM,
        tabledata "ICR Approval History" = R,
        tabledata "ICR Processing Unit" = RIM,
        tabledata "ICR Reconciliation Result" = RIM,
        codeunit "ICR Recharge Mgt." = X,
        page "ICR Recharge Requests" = X,
        page "ICR Recharge Request Card" = X,
        page "ICR Posting Links" = X,
        page "ICR Operational Monitor" = X,
        page "ICR Reconciliation Results" = X;
}

permissionset 50104 "ICR AUDITOR"
{
    Assignable = true;
    Caption = 'Intercompany Recharge Auditor';
    Permissions =
        tabledata "ICR Recharge Setup" = R,
        tabledata "ICR Partner Rule" = R,
        tabledata "ICR Dimension Rule" = R,
        tabledata "ICR Driver Value" = R,
        tabledata "ICR Recharge Request" = R,
        tabledata "ICR Recharge Source Line" = R,
        tabledata "ICR Recharge Allocation Line" = R,
        tabledata "ICR Recharge Posting Link" = R,
        tabledata "ICR Recharge Audit Event" = R,
        tabledata "ICR Recharge Exception" = R,
        tabledata "ICR Approval History" = R,
        tabledata "ICR Processing Unit" = R,
        tabledata "ICR Reconciliation Result" = R,
        page "ICR Audit Events" = X,
        page "ICR Approval History" = X,
        page "ICR Reconciliation Results" = X,
        page "ICR Posting Links" = X;
}
