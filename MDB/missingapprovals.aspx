<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="missingapprovals.aspx.cs" Inherits="MDB.missingapprovals" %>
<%@ Register Src="~/Controls/HoverMenu.ascx" TagPrefix="MDB" TagName="HoverMenu" %>
<%@ Register Src="~/Controls/HoverDetails.ascx" TagPrefix="MDB" TagName="HoverDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphMain" runat="server">
    <div class="infobox">
        <div>
            <img src="/Content/images/icon_info.png" class="icon" />
        </div>
        <div>
            <asp:Label Text="Kolonnerne <b>Ændringsdato</b> og <b>Ændret af</b> viser den sidste bruger der har ændret stabsnummer på MA og dermed mangler at bekræfte om info passer." runat="server" />
        </div>
    </div>
    <asp:Label ID="lblRowCount" runat="server" Text="lblRowCount"></asp:Label>
    <asp:GridView ID="gvOrders" runat="server" OnRowCommand="gvOrders_RowCommand" CssClass="gridview list" OnDataBound="gvOrders_DataBound" ShowHeaderWhenEmpty="True" AutoGenerateColumns="False" AllowSorting="True" DataSourceID="sdsOrders" DataKeyNames="OrderId">
        <Columns>
            <asp:BoundField DataField="OrderId" HeaderText="Ordre" ReadOnly="True" SortExpression="OrderId" />
            <asp:BoundField DataField="TimeStamp" HeaderText="Ændringsdato" DataFormatString="{0:dd-MM-yyyy}" SortExpression="TimeStamp" />
            <asp:TemplateField HeaderText="Genstand" SortExpression="ObjectNumber">
                <ItemTemplate>
                    <asp:HyperLink runat="server" ID="hplObject" NavigateUrl='<%# $"~/order/{Eval("OrderId")}" %>'
                        Text='<%# ((int)Eval("ObjectTypeRefId") == 3 ? "IMEI " : "SIMNR ") + Eval("ObjectNumber") %>' />
                    <MDB:HoverMenu runat="server" TargetControlID="hplObject" ID="HoverMenu">
                        <Content>
                            <asp:LinkButton ID="lnkbtnApprove" runat="server" Text="Bekræft ny stilling" CommandName="Approve" CommandArgument='<%# Eval("OrderId") %>' />
                            <asp:LinkButton ID="lnkbtnStorage" runat="server" Text="Sæt på Lager" CommandName="Storage" CommandArgument='<%# Eval("OrderId") %>' />
                        </Content>
                    </MDB:HoverMenu>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Info" HeaderText="Nummer/model" SortExpression="Info" />
            <asp:TemplateField HeaderText="Udleveret til" SortExpression="Stabsnummer">
                <ItemTemplate>
                    <asp:HyperLink ID="hplEmployee" NavigateUrl='<%# $"~/employee/{Eval("EmployeeId")}" %>' runat="server"><%# $"{Eval("Stabsnummer")} {Eval("Name")}" %></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Oprettet af" SortExpression="ExecutorFull">
                <ItemTemplate>
                    <MDB:HoverDetails runat="server" Text='<%# Eval("ExecutorShort") %>'
                        TextFull='<%# Eval("ExecutorFull") %>' ID="HoverDetails" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="sdsOrders" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT * FROM [UnapprovedOrdersView] ORDER BY [TimeStamp]">
    </asp:SqlDataSource>
</asp:Content>