<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="bulkupdate.aspx.cs" Inherits="MDB.admin.bulkupdate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    -Brugere bliver kun opdateret hvis de findes, ikke oprettet<br />
    -Stabsnummer bliver automatisk rettet til stort og mellemrum bliver trimmet væk<br />
    -Man får at vide om MA har udleverede genstande<br />
    <div class="bulkupdate">
        <div>
            <asp:TextBox ID="txtInput" runat="server" placeholder="123456;TRR-XXXX" TextMode="MultiLine"></asp:TextBox>
            <asp:Button ID="btnRun" runat="server" Text="Kør" OnClick="btnRun_Click" />
        </div>
        <asp:Label ID="lblOutput" runat="server" Text=""></asp:Label>
    </div>
</asp:Content>