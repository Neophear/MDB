<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TextBoxWithOptions.ascx.cs" Inherits="MDB.Controls.TextBoxWithOptions" %>
<div class="textwithoptions">
    <asp:TextBox ID="txt" Text='<%# PreferInput && LinePart.InputPart != "" ? LinePart.InputPart : LinePart.ToString() %>' CssClass='<%# LinePart.IsGood() ? "" : "warning" %>' runat="server"></asp:TextBox>
    <ajaxToolkit:HoverMenuExtender ID="hme" Enabled='<%# !LinePart.IsGood() %>' runat="Server"
        TargetControlID="txt"
        PopupControlID="pnl"
        PopupPosition="Right"
        OffsetX="0"
        OffsetY="-10"
        PopDelay="50"/>
    <asp:Panel ID="pnl" Visible='<%# !LinePart.IsGood() %>' runat="server">
        <asp:PlaceHolder ID="phMessage" runat="server" Visible='<%# LinePart.Message != "" %>'>
            <span>Besked:</span><asp:Label ID="lblMessage" runat="server" Text='<%# LinePart.Message %>'></asp:Label>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="phOptions" Visible='<%# LinePart.DBPart != "" && LinePart.InputPart != "" %>' runat="server">
            <span>Input:</span><asp:Label ID="lblOption1" data-type="insert" runat="server" Text='<%# LinePart.InputPart %>'></asp:Label><br />
            <span>DB:</span><asp:Label ID="lblOption2" data-type="insert" runat="server" Text='<%# LinePart.DBPart %>'></asp:Label>
        </asp:PlaceHolder>
    </asp:Panel>
</div>