<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="users.aspx.cs" Inherits="MDB.admin.users" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:HyperLink ID="hplInsertUser" runat="server" CssClass="insertlink" NavigateUrl="~/admin/user">Opret</asp:HyperLink>
    <asp:GridView ID="gvUsers" AllowSorting="true" CssClass="gridview list" OnSorting="gvUsers_Sorting" OnRowDataBound="gvUsers_RowDataBound" AutoGenerateColumns="false" runat="server">
        <Columns>
            <asp:BoundField DataField="UserName" HeaderText="MANR" SortExpression="UserName" />
            <asp:BoundField DataField="FullName" HeaderText="Navn" SortExpression="FullName" />
            <asp:TemplateField HeaderText="Aktiv" SortExpression="Enabled">
                <ItemTemplate>
                    <asp:Label ID="lblEnabled" runat="server" Text='<%# (bool)Eval("Enabled") ? "Ja" : "Nej" %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Låst" SortExpression="IsLockedOut">
                <ItemTemplate>
                    <asp:Label ID="lblIsLockedOut" runat="server" Text='<%# (bool)Eval("IsLockedOut") ? "Ja" : "Nej" %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" />
            <asp:BoundField DataField="CreationDate" DataFormatString="{0:dd-MM-yy HH:mm}" HeaderText="Oprettet" SortExpression="CreationDate" />
            <asp:BoundField DataField="LastLoginDate" DataFormatString="{0:dd-MM-yy HH:mm}" HeaderText="Sidste login" SortExpression="LastLoginDate" />
            <asp:BoundField DataField="LastActivityDate" DataFormatString="{0:dd-MM-yy HH:mm}" HeaderText="Sidste aktivitet" SortExpression="LastActivityDate" />
        </Columns>
    </asp:GridView>
</asp:Content>