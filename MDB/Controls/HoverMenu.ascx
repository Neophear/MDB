<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HoverMenu.ascx.cs" Inherits="MDB.Controls.HoverMenu" %>

<ajaxToolkit:HoverMenuExtender ID="hme" Enabled='<%# Enabled %>' PopupPosition="Right" OffsetX="5" OffsetY="-10" PopupControlID="pnlHoverMenu" runat="server" />
<asp:Panel ID="pnlHoverMenu" Enabled='<%# Enabled %>' CssClass="hovermenu" runat="server">
    <asp:Label ID="lblTitle" runat="server" Text="Menu"></asp:Label>
    <asp:PlaceHolder ID="phContent" runat="server" />
</asp:Panel>