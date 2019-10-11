<%@ Page Title="Medarbejdere" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="employees.aspx.cs" Inherits="MDB.employees" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Label ID="lblRowCount" runat="server" Text="lblRowCount"></asp:Label>
    <asp:GridView ID="gvEmployees" runat="server" OnDataBound="gvEmployees_DataBound" OnSorting="gvEmployees_Sorting" CssClass="gridview list" OnPageIndexChanging="gvEmployees_PageIndexChanging" PageSize="50" PagerSettings-PageButtonCount="25" ShowHeaderWhenEmpty="true" OnRowDataBound="gvEmployees_RowDataBound" AllowPaging="True" AutoGenerateColumns="false" AllowSorting="True" DataSourceID="sdsEmployees">
        <Columns>
            <asp:TemplateField SortExpression="MANR">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblMANR" runat="server" Text="MANR" CommandName="Sort" CommandArgument="MANR"></asp:LinkButton>
                    <br />
                    <asp:TextBox runat="server" ID="txtMANR" AutoPostBack="true"></asp:TextBox>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# Eval("MANR") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField SortExpression="Stabsnummer">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblStabsnummer" runat="server" Text="Stabsnummer" CommandName="Sort" CommandArgument="Stabsnummer"></asp:LinkButton>
                    <br />
                    <asp:TextBox runat="server" ID="txtStabsnummer" AutoPostBack="true"></asp:TextBox>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# Eval("Stabsnummer") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField SortExpression="Name">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblName" runat="server" Text="Navn" CommandName="Sort" CommandArgument="Name"></asp:LinkButton>
                    <br />
                    <asp:TextBox runat="server" ID="txtName" AutoPostBack="true"></asp:TextBox>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# Eval("Name") %>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsEmployees" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT [Id], [MANR], [Stabsnummer], [Name] FROM [Employees]"
        FilterExpression="MANR LIKE '%{0}%' AND Stabsnummer LIKE '%{1}%' AND Name LIKE '%{2}%'">
        <FilterParameters>
            <asp:Parameter Name="@MANR" Type="String" ConvertEmptyStringToNull="false" />
            <asp:Parameter Name="@Stabsnummer" Type="String" ConvertEmptyStringToNull="false" />
            <asp:Parameter Name="@Name" Type="String" ConvertEmptyStringToNull="false" />
        </FilterParameters>
    </asp:SqlDataSource>
</asp:Content>