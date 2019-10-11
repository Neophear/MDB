<%@ Page Title="Forside" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MDB.Default" %>
<%@ Import Namespace="Stiig" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <meta http-equiv="refresh" content="60"/>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <div class="left">
        <asp:ListView ID="lvNews" runat="server" DataSourceID="sdsNews" DataKeyField="ID">
            <ItemTemplate>
                <table class='news <%# (bool)Eval("Sticky") ? " newsSticky": "newsNormal" %>'>
                    <tr>
                        <td>
                            <asp:Label ID="lblTitle" CssClass="left" runat="server" Text='<%# Eval("Title") %>'></asp:Label>
                            <asp:Label ID="lblTimeStamp" CssClass="right" runat="server" Text='<%# Utilities.GetFriendlyTime((DateTime)Eval("TimeStamp")) %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblText" runat="server" Text='<%# Utilities.BBToHTML(Eval("Content").ToString()) %>'></asp:Label>
                        </td>
                    </tr>
                    <asp:Panel ID="pnlAdmin" Visible='<%# User.IsInRole("Admin") %>' runat="server">
                        <tr>
                            <td>
                                <asp:Label ID="lblVisibleTo" CssClass="left" runat="server" Text='<%# Eval("VisibleTo") %>'></asp:Label>
                                <asp:HyperLink ID="hplEdit" CssClass="right" NavigateUrl='<%# ResolveClientUrl($"~/admin/news/{Eval("Id")}") %>' runat="server">Rediger</asp:HyperLink>
                            </td>
                        </tr>
                    </asp:Panel>
                </table>
            </ItemTemplate>
        </asp:ListView><br />
        <asp:DataPager ID="dpNews" runat="server" PagedControlID="lvNews" PageSize="5">
            <Fields>
                <asp:NextPreviousPagerField FirstPageText="Første" LastPageText="Sidste" NextPageText="Næste" PreviousPageText="Forrige" />
                <asp:NumericPagerField />
            </Fields>
        </asp:DataPager>
        <asp:SqlDataSource ID="sdsNews" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" OnSelected="sdsNews_Selected" OnSelecting="sdsNews_Selecting" SelectCommand="GetNews" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:Parameter Name="Role" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <div class="right">
        <asp:ListView ID="lvChangeLog" runat="server" DataSourceID="sdsChangeLog">
            <ItemTemplate>
                <table class="changelog">
                    <tr>
                        <td>
                            <asp:Label ID="lblTimeStamp" runat="server" CssClass="right" Text='<%# Utilities.GetFriendlyTime((DateTime)Eval("Timestamp")) %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblText" runat="server" Text='<%# Eval("Text") %>'></asp:Label>
                        </td>
                    </tr>
                    <asp:Panel ID="pnlAdmin" Visible='<%# User.IsInRole("Admin") %>' runat="server">
                        <tr>
                            <td>
                                <asp:Label ID="lblVisibleTo" CssClass="left" runat="server" Text='<%# Eval("VisibleTo") %>'></asp:Label>
                            </td>
                        </tr>
                    </asp:Panel>
                </table>
            </ItemTemplate>
        </asp:ListView>
        <asp:SqlDataSource ID="sdsChangeLog" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            OnSelecting="sdsChangeLog_Selecting" SelectCommandType="StoredProcedure" SelectCommand="GetChangeLog">
            <SelectParameters>
                <asp:Parameter Name="Role" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <div style="clear:both;"></div>
</asp:Content>