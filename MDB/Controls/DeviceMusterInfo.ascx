<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DeviceMusterInfo.ascx.cs" Inherits="MDB.Controls.DeviceMusterInfo" %>
<%@ Register Src="~/Controls/ReqTextBox.ascx" TagPrefix="MDB" TagName="ReqTextBox" %>
<%@ Register Assembly="MDB" Namespace="MDB.Controls" TagPrefix="MDB" %>

<asp:UpdatePanel ID="upDevice" runat="server">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnCreateDevice" />
    </Triggers>
    <ContentTemplate>
        <asp:Label runat="server" ID="lblIMEI" />
        <asp:HiddenField ID="hdnIMEI" Value='<%# Eval("IMEI") %>' runat="server" />
        <asp:Image ID="imgWarning" CssClass="icon_small" ImageUrl="~/Content/images/icon_redwarning.png" runat="server" />
        <ajaxToolkit:HoverMenuExtender ID="hmeDevice" TargetControlID="lblIMEI" PopupControlID="pnlDevice" PopupPosition="Right" OffsetX="10" OffsetY="-5" runat="server" />
        <asp:Panel ID="pnlDevice" CssClass="detailstooltip" runat="server">
            <asp:PlaceHolder ID="phNullDevice" runat="server">
                <asp:Label ID="lblWarning" runat="server" Text='<%# Eval("IMEI") + " ikke oprettet!" %>' /><br />
                <asp:Label ID="lblOther" runat="server" Visible="false" Text="Bruger har registreret disse:"></asp:Label>
                <asp:Repeater ID="rptOtherDevices" OnItemDataBound="rptOtherDevices_ItemDataBound" runat="server">
                    <ItemTemplate>
                        <br /><asp:Label ID="lblDevice" runat="server" Text='<%# Eval("IMEI") %>' />
                    </ItemTemplate>
                </asp:Repeater>
                <br />
                <asp:Label ID="lblCreateMsg" runat="server" Text="lblCreateMsg" Visible="false"></asp:Label>

                <asp:PlaceHolder ID="phCreate" runat="server">
                    <br /><br />Opret:
                    <table>
                        <tr>
                            <td>
                                IMEI
                            </td>
                            <td>
                                <MDB:ReqTextBox runat="server" ID="rtxtIMEI" CheckIfExists="Device" MinLength="1" MaxLength="50" PropertyText="IMEI" Text='<%# Eval("IMEI") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Model
                            </td>
                            <td>
                                <MDB:ReqTextBox runat="server" ID="rtxtModel" MinLength="1" MaxLength="50" ServiceMethod="GetModels" PropertyText="Model" />
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
                            <td>
                                Type
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlType" runat="server" DataSourceID="sdsType" AppendDataBoundItems="true" DataTextField="Name" DataValueField="Id">
                                    <asp:ListItem Selected="True" Value="">-Vælg type-</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sdsType" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [Id], [Name] FROM [DeviceTypes]"></asp:SqlDataSource>
                                <asp:RequiredFieldValidator ID="rfvType" runat="server" ControlToValidate="ddlType" ErrorMessage="Du skal vælge en type"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:Button ID="btnCreateDevice" runat="server" OnClick="btnCreateDevice_Click" Text="Opret" />
                            </td>
                        </tr>
                    </table>
                </asp:PlaceHolder>
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="phDevice" runat="server">
                Model: <asp:Label ID="lblPhoneModel" runat="server" /><br />
                Leverandør: <asp:Label ID="lblProvider" runat="server" /><br />
                Type: <asp:Label ID="lblType" runat="server" /><br />
                Status: <asp:Label ID="lblStatus" runat="server" />
            </asp:PlaceHolder>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>