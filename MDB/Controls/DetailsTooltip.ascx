<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DetailsTooltip.ascx.cs" Inherits="MDB.Controls.DetailsTooltip" %>
<asp:Image ID="imgDetails" CssClass="icon_small" Visible='<%# !String.IsNullOrWhiteSpace(Text) %>' ImageUrl="~/Content/images/icon_details.png" runat="server" />
<ajaxToolkit:PopupControlExtender ID="pceDetails" Enabled='<%# !String.IsNullOrWhiteSpace(Text) %>' PopupControlID="pnlTooltip" OffsetX="20"  TargetControlID="imgDetails" runat="server"></ajaxToolkit:PopupControlExtender>
<asp:Panel ID="pnlTooltip" runat="server" Visible='<%# !String.IsNullOrWhiteSpace(Text) %>' CssClass="detailstooltip">
    <asp:Label ID="lblText" runat="server" Text='<%# Text %>'></asp:Label>
</asp:Panel>