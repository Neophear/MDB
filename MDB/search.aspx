<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="search.aspx.cs" Inherits="MDB.search" %>
<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:GridView ID="gvSearch" runat="server" CssClass="gridview list" AllowSorting="true" OnRowDataBound="gvSearch_RowDataBound" AutoGenerateColumns="False" DataSourceID="sdsSearch">
        <EmptyDataTemplate>
            <h3>
                Ingen resultater<br />
                <asp:Label ID="lblNoResults" runat="server" Text='<%# RouteData.Values["string"] %>'></asp:Label>
            </h3>
        </EmptyDataTemplate>
        <Columns>
            <asp:BoundField DataField="TypeName" HeaderText="Type" SortExpression="TypeName" />
            <asp:BoundField DataField="UniqueIdentifier" HeaderText="MANR/IMEI/SIMnummer" SortExpression="UniqueIdentifier" />
            <asp:BoundField DataField="Info" HeaderText="Nummer/model" SortExpression="Info" />
            <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
            <asp:TemplateField HeaderText="Bruger" SortExpression="Stabsnummer">
                <ItemTemplate>
                    <asp:Label ID="lblUser" runat="server" Visible='<%# Eval("MANR") != DBNull.Value %>' Text='<%# ((int)Eval("TypeId") == 2 ? "" : "Udleveret til ") + $"{Eval("Stabsnummer")} {Eval("Name")}" %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsSearch" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [AllObjectsView] WHERE ([UniqueIdentifier] LIKE '%' + @SearchString + '%') OR ([TypeId] = 2 AND ([Stabsnummer] LIKE '%' + @SearchString + '%' OR [Name] LIKE '%' + @SearchString + '%')) OR ([Info] LIKE '%' + @SearchString + '%') ORDER BY [TypeName], [UniqueIdentifier]">
        <SelectParameters>
            <asp:RouteParameter Name="SearchString" RouteKey="string" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>