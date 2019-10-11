using MDB.AppCode;
using Stiig;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB.Controls
{
    public partial class DeviceMusterInfo : System.Web.UI.UserControl
    {
        public string IMEI { get; set; }
        public Device Device { get; set; }
        public Employee Employee { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected override void OnDataBinding(EventArgs e)
        {
            base.OnDataBinding(e);
            lblIMEI.Text = IMEI;
            phNullDevice.Visible = Device == null;
            imgWarning.Visible = Device == null;
            phDevice.Visible = Device != null;

            if (Device != null)
            {
                lblPhoneModel.Text = Device.Model;
                lblProvider.Text = Device.Provider;
                lblType.Text = Device.Type;
                lblStatus.Text = Device.CurrentStatus;
            }
            else
            {
                if (Employee != null)
                {
                    List<Device> devices = Device.FindDevices(Employee);
                    rptOtherDevices.DataSource = devices;
                    rptOtherDevices.DataBind();

                    lblOther.Visible = devices.Count > 0;
                }

                rtxtIMEI.ValidationGroup = this.ClientID;
                rtxtModel.ValidationGroup = this.ClientID;
                rtxtProvider.ValidationGroup = this.ClientID;
                rfvUnit.ValidationGroup = this.ClientID;
                rfvType.ValidationGroup = this.ClientID;
                btnCreateDevice.ValidationGroup = this.ClientID;
            }
        }

        protected void rptOtherDevices_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item)
            {
                Label lblDevice = (Label)e.Item.FindControl("lblDevice");
                lblDevice.Attributes.Add("data-type", "correctnumber");
                lblDevice.Attributes.Add("data-target", hdnIMEI.ClientID);
            }
        }

        protected void btnCreateDevice_Click(object sender, EventArgs e)
        {
            string imei = rtxtIMEI.Text.Trim();

            if (imei != "")
            {
                DeviceWithResult d = (DeviceWithResult)Device.GetDevice(imei);

                if (d == null)
                {
                    d = new DeviceWithResult
                    {
                        IMEI = imei,
                        Model = rtxtModel.Text,
                        Provider = rtxtProvider.Text,
                        OrderNumber = "",
                        UnitId = int.Parse(ddlUnit.SelectedValue),
                        TypeId = int.Parse(ddlType.SelectedValue),
                        Notes = $"Oprettet under mønstring {DateTime.Today.ToString("yyyyMMdd")}"
                    };

                    if (d.Save())
                    {
                        d.Result = "Oprettet";
                        phCreate.Visible = false;
                        imgWarning.Visible = false;
                        lblWarning.Visible = false;
                        rptOtherDevices.Visible = false;
                        lblIMEI.Text = imei;
                        hdnIMEI.Value = imei;
                    }
                    else
                        d.Result = "Noget gik galt";
                }
                else
                    d.Result = "Findes i forvejen";

                lblCreateMsg.Text = d.Result;
                lblCreateMsg.Visible = true;
            }
        }
    }
}