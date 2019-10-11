<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HoverDetails.ascx.cs" Inherits="MDB.Controls.HoverDetails" %>
<asp:Label runat="server" ID="lbl" />
<ajaxToolkit:HoverMenuExtender TargetControlID="lbl" PopupControlID="pnl" OffsetX="-6" OffsetY="-1" runat="server" />
<asp:Panel ID="pnl" CssClass="hoverdetails" runat="server">
    <asp:Label runat="server" ID="lblFull" />
</asp:Panel>