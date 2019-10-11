<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SimcardMusterInfo.ascx.cs" Inherits="MDB.Controls.SimcardMusterInfo" %>
<%@ Register Src="~/Controls/ReqTextBox.ascx" TagPrefix="MDB" TagName="ReqTextBox" %>
<%@ Register Assembly="MDB" Namespace="MDB.Controls" TagPrefix="MDB" %>

<asp:UpdatePanel ID="upSimcard" runat="server">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnCreateSimcard" />
    </Triggers>
    <ContentTemplate>
        <asp:Label runat="server" ID="lblSimnumber" />
        <asp:HiddenField ID="hdnSimnumber" Value='<%# Eval("Simnumber") %>' runat="server" />
        <asp:Image ID="imgWarning" CssClass="icon_small" ImageUrl="~/Content/images/icon_redwarning.png" runat="server" />
        <ajaxToolkit:HoverMenuExtender ID="hmeSimcard" TargetControlID="lblSimnumber" PopupControlID="pnlSimcard" PopupPosition="Right" OffsetX="10" OffsetY="-5" runat="server" />
        <asp:Panel ID="pnlSimcard" CssClass="detailstooltip" runat="server">
            <asp:PlaceHolder ID="phNullSimcard" runat="server">
                <asp:Label ID="lblWarning" runat="server" Text='<%# Eval("Simnumber") + " ikke oprettet!" %>' /><br />
                <asp:Label ID="lblOther" runat="server" Visible="false" Text="Bruger har registreret disse:"></asp:Label>
                <asp:Repeater ID="rptOtherSimcards" OnItemDataBound="rptOtherSimcards_ItemDataBound" runat="server">
                    <ItemTemplate>
                        <br /><asp:Label ID="lblSimcard" runat="server" Text='<%# Eval("Simnumber") %>' />
                    </ItemTemplate>
                </asp:Repeater>
                <br />
                <asp:Label ID="lblCreateMsg" runat="server" Text="lblCreateMsg" Visible="false"></asp:Label>
                <asp:PlaceHolder ID="phCreate" runat="server">
                    <br /><br />Opret:
                    <table>
                        <tr>
                            <td>
                                Simkort-nummer
                            </td>
                            <td>
                                <MDB:ReqTextBox runat="server" ID="rtxtSimnumber" CheckIfExists="Simcard" MinLength="1" MaxLength="50" PropertyText="SIMnummer" Text='<%# Eval("Simnumber") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Nummer
                            </td>
                            <td>
                                <asp:TextBox ID="txtNumber" runat="server" MaxLength="50"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Udbyder
                            </td>
                            <td>
                                <MDB:ReqTextBox runat="server" ID="rtxtProvider" MinLength="1" MaxLength="50" ServiceMethod="GetProviders" PropertyText="Udbyder" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Enhed
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlUnit" runat="server" DataSourceID="sdsUnit" AppendDataBoundItems="true" DataTextField="Name" DataValueField="Id">
                                    <asp:ListItem Selected="True" Value="">-Vælg MYN-</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [Units]"></asp:SqlDataSource>
                                <asp:RequiredFieldValidator ID="rfvUnit" runat="server" ControlToValidate="ddlUnit" ErrorMessage="Du skal vælge en myndighed"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:Button ID="btnCreateSimcard" runat="server" OnClick="btnCreateSimcard_Click" Text="Opret" />
                            </td>
                        </tr>
                    </table>
                </asp:PlaceHolder>
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="phSimcard" runat="server">
                Nummer: <asp:Label ID="lblNumber" runat="server" /><br />
                Leverandør: <asp:Label ID="lblProvider" runat="server" /><br />
                Status: <asp:Label ID="lblStatus" runat="server" />
            </asp:PlaceHolder>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>