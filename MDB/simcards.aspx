<%@ Page Title="SIM-kort" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="simcards.aspx.cs" Inherits="MDB.simcards" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <asp:Label ID="lblRowCount" runat="server" Text="lblRowCount"></asp:Label>
    <asp:GridView ID="gvSimcards" runat="server" PagerStyle-CssClass="pager" OnDataBound="gvSimcards_DataBound" OnPageIndexChanging="gvSimcards_PageIndexChanging" PageSize="50" PagerSettings-PageButtonCount="20" OnSorting="gvSimcards_Sorting" CssClass="gridview list" ShowHeaderWhenEmpty="true" OnRowDataBound="gvSimcards_RowDataBound" AllowPaging="True" AutoGenerateColumns="false" AllowSorting="True" DataSourceID="sdsSimcards">
        <Columns>
            <asp:TemplateField SortExpression="Simnumber">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblSimnumber" runat="server" Text="SIMnummer" CommandName="Sort" CommandArgument="Simnumber"></asp:LinkButton>
                    <br />
                    <asp:TextBox runat="server" ID="txtSimnumber" AutoPostBack="true"></asp:TextBox>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# Eval("Simnumber") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField SortExpression="Number">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblNumber" runat="server" Text="Nummer" CommandName="Sort" CommandArgument="Number"></asp:LinkButton>
                    <br />
                    <asp:TextBox runat="server" ID="txtNumber" AutoPostBack="true"></asp:TextBox>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# Eval("Number") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField Visible="false" SortExpression="Type">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblType" runat="server" Text="Type" CommandName="Sort" CommandArgument="Type"></asp:LinkButton>
                    <br />
                    <asp:DropDownList ID="ddlType" runat="server" AutoPostBack="True">
                        <asp:ListItem Selected="True" Value="%">-Vælg type-</asp:ListItem>
                        <asp:ListItem>Tale</asp:ListItem>
                        <asp:ListItem>Data</asp:ListItem>
                    </asp:DropDownList>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# Eval("Type") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField SortExpression="Provider">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblProvider" runat="server" Text="Leverandør" CommandName="Sort" CommandArgument="Provider"></asp:LinkButton>
                    <br />
                    <asp:TextBox runat="server" ID="txtProvider" AutoPostBack="true"></asp:TextBox>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# Eval("Provider") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField SortExpression="Unit">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblUnit" runat="server" Text="MYN" CommandName="Sort" CommandArgument="Unit"></asp:LinkButton>
                    <br />
                    <asp:DropDownList ID="ddlUnit" runat="server" AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="sdsUnit" DataTextField="Short" DataValueField="Short">
                        <asp:ListItem Selected="True" Value="%">-Vælg MYN-</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Short] FROM [Units]"></asp:SqlDataSource>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# Eval("Unit") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField SortExpression="Status">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblStatus" runat="server" Text="Status" CommandName="Sort" CommandArgument="Status"></asp:LinkButton>
                    <br />
                    <asp:DropDownList ID="ddlStatus" runat="server" AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="sdsStatus" DataTextField="Name" DataValueField="Name">
                        <asp:ListItem Selected="True" Value="%">-Vælg status-</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="sdsStatus" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Name] FROM [Status] WHERE [ObjectTypeRefId] = 4"></asp:SqlDataSource>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# Eval("Status") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField SortExpression="TaxType">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblTaxType" runat="server" Text="Beskatning" CommandName="Sort" CommandArgument="TaxType"></asp:LinkButton>
                    <br />
                    <asp:DropDownList ID="ddlTaxType" runat="server" AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="sdsTaxType" DataTextField="Name" DataValueField="Name">
                        <asp:ListItem Selected="True" Value="%">-Vælg beskatning-</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="sdsTaxType" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Name] FROM [TaxTypes]"></asp:SqlDataSource>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# Eval("TaxType") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField SortExpression="Stabsnummer">
                <HeaderTemplate>
                    <asp:LinkButton ID="lblEmployee" runat="server" Text="Medarbejder" CommandName="Sort" CommandArgument="Stabsnummer"></asp:LinkButton>
                    <br />
                    <asp:TextBox runat="server" ID="txtEmployee" AutoPostBack="true"></asp:TextBox>
                </HeaderTemplate>
                <ItemTemplate>
                    <%# $"{Eval("Stabsnummer")} {Eval("Name")}" %>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsSimcards" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT [Id], [Simnumber], [Number], [IsData], [Type], [Provider], [UnitRefId], [Unit], [Status], [TaxType], [Stabsnummer], [Name] FROM [SimcardView]"
        FilterExpression="Simnumber LIKE '%{0}%' AND Number LIKE '%{1}%' AND Type LIKE '{2}' AND Provider LIKE '%{3}%' AND Unit LIKE '{4}' AND Status LIKE '{5}' AND TaxType LIKE '{6}' AND (((Stabsnummer IS NULL AND '{7}' = '') OR Stabsnummer LIKE '%{7}%') OR ((Name IS NULL AND '{7}' = '') OR Name LIKE '%{7}%'))">
        <FilterParameters>
            <asp:Parameter Name="@Simnumber" Type="String" ConvertEmptyStringToNull="false" />
            <asp:Parameter Name="@Number" Type="String" ConvertEmptyStringToNull="false" />
            <asp:Parameter Name="@Type" Type="String" ConvertEmptyStringToNull="false" />
            <asp:Parameter Name="@Provider" Type="String" ConvertEmptyStringToNull="false" />
            <asp:Parameter Name="@Unit" Type="String" ConvertEmptyStringToNull="false" />
            <asp:Parameter Name="@Status" Type="String" ConvertEmptyStringToNull="false" />
            <asp:Parameter Name="@TaxType" Type="String" ConvertEmptyStringToNull="false" />
            <asp:Parameter Name="@Employee" Type="String" ConvertEmptyStringToNull="false" />
        </FilterParameters>
    </asp:SqlDataSource>
</asp:Content>
