using System;
using System.Collections.Generic;
using System.Data;
using System.Text.RegularExpressions;
using System.Web.Security;
using Stiig;

namespace MDB.AppCode
{
    public static class Functions
    {
        public static object GetCurrentUserId()
        {
            return Membership.GetUser().ProviderUserKey;
        }

        public static bool CheckIfObjectExists(string searchQuery, ObjectType type, int? id = null)
        {
            DataAccessLayer dal = new DataAccessLayer();
            dal.AddParameter("@searchQuery", searchQuery, DbType.String);
            dal.AddParameter("@objectType", type, DbType.Int16);
            dal.AddParameter("@Id", (object)id ?? DBNull.Value, DbType.Int32);
            bool result = (bool)dal.ExecuteScalar("SELECT dbo.CheckIfObjectExist(@searchQuery, @objectType, @Id)");
            dal.ClearParameters();
            return result;
        }

        public enum ObjectType
        {
            Unit = 1,
            Employee = 2,
            Device = 3,
            Simcard = 4,
            SQLPreset = 11
        }
    }

    /// <summary>
    /// MobilDataBase user
    /// </summary>
    public class MDBUser
    {
        private MembershipUser _user;
        private string _firstname;
        private string _lastname;
        private UserType? _type;
        private bool? _enabled;

        public string UserName { get { return _user.UserName; } }
        /// <summary>
        /// Remember to save after setting firstname, lastname or admin!
        /// </summary>
        public string Firstname
        {
            get
            {
                if (String.IsNullOrEmpty(_firstname))
                    GetFullName();

                return _firstname;
            }
            set { _firstname = value; }
        }
        /// <summary>
        /// Remember to save after setting firstname, lastname or type!
        /// </summary>
        public string Lastname
        {
            get
            {
                if (String.IsNullOrEmpty(_lastname))
                    GetFullName();

                return _lastname;
            }
            set { _lastname = value; }
        }
        public string FullName { get { return $"{Firstname} {Lastname}".Trim(); } }
        /// <summary>
        /// Remember to save after setting firstname, lastname or type!
        /// </summary>
        public UserType Type
        {
            get
            {
                if (_type == null)
                {
                    switch (Roles.GetRolesForUser(UserName)[0])
                    {
                        case "Admin":
                            _type = UserType.Admin;
                            break;
                        case "Write":
                            _type = UserType.Write;
                            break;
                        case "Read":
                            _type = UserType.Read;
                            break;
                        default:
                            _type = UserType.Read;
                            break;
                    }
                }

                return _type.Value;
            }
            set
            {
                _type = value;
            }
        }

        public bool Enabled
        {
            get
            {
                if (_enabled == null)
                    _enabled = _user.IsApproved;

                return _enabled.Value;
            }
            set { _enabled = value; }
        }
        public DateTime? CreationDate { get { return _user.CreationDate; } }
        public DateTime? LastLoginDate
        {
            get
            {
                return _user.LastLoginDate == _user.CreationDate ? null : new DateTime?(_user.LastLoginDate);
            }
        }
        public DateTime? LastActivityDate
        {
            get
            {
                //return new DateTime?(_user.LastActivityDate);
                return _user.LastActivityDate == _user.CreationDate ? null : new DateTime?(_user.LastActivityDate);
            }
        }
        public bool IsLockedOut { get { return _user.IsLockedOut; } }
        public string DisplayName { get { return String.IsNullOrEmpty(FullName) ? UserName : $"{UserName} - {FullName}"; } }

        public MDBUser()
        {
            
        }

        private MDBUser(MembershipUser u, string firstname = null, string lastname = null)
        {
            _user = u;
            _firstname = firstname;
            _lastname = lastname;
        }
        
        private void GetFullName()
        {
            DataAccessLayer dal = new DataAccessLayer();
            dal.AddParameter("@Username", UserName, System.Data.DbType.String);
            dal.AddParameter("@Firstname", null, System.Data.DbType.String, System.Data.ParameterDirection.Output);
            dal.AddParameter("@Lastname", null, System.Data.DbType.String, System.Data.ParameterDirection.Output);
            dal.ExecuteStoredProcedure("GetFullName");
            _firstname = $"{dal.GetParameterValue("@Firstname")}";
            _lastname = $"{dal.GetParameterValue("@Lastname")}";
            dal.ClearParameters();
        }
        public string Save(bool unlock = false, bool resetPassword = false)
        {
            DataAccessLayer dal = new DataAccessLayer();
            dal.AddParameter("@Username", UserName, System.Data.DbType.String);
            dal.AddParameter("@Firstname", _firstname, System.Data.DbType.String);
            dal.AddParameter("@Lastname", _lastname, System.Data.DbType.String);
            dal.AddParameter("@UserType", _type, System.Data.DbType.Int16);
            dal.AddParameter("@Enabled", _enabled, System.Data.DbType.Boolean);
            dal.AddParameter("@Unlock", unlock, System.Data.DbType.Boolean);
            dal.AddParameter("@PasswordReset", resetPassword, System.Data.DbType.Boolean);
            dal.AddParameter("@Executor", Membership.GetUser().UserName, System.Data.DbType.String);
            dal.ExecuteStoredProcedure("UserUpdate");
            dal.ClearParameters();

            string newPassword = null;
            if (resetPassword)
            {
                newPassword = Globals.GetRandomPassword().GeneratePassword();
                _user.ChangePassword(_user.ResetPassword(), newPassword);
            }

            return newPassword;
        }

        public void ChangePassword(string password, bool unlock = true)
        {
            _user.ChangePassword(_user.ResetPassword(), password);

            DataAccessLayer dal = new DataAccessLayer();
            dal.AddParameter("@Username", UserName, DbType.String);
            dal.AddParameter("@Executor", Membership.GetUser().UserName, DbType.String);
            dal.AddParameter("@Unlock", unlock, DbType.Boolean);
            dal.ExecuteStoredProcedure("UserChangedPassword");
            dal.ClearParameters();
        }

        public static void Delete(string username)
        {
            DataAccessLayer dal = new DataAccessLayer();
            dal.AddParameter("@Username", username, DbType.String);
            dal.AddParameter("@Executor", Membership.GetUser().UserName, DbType.String);
            dal.ExecuteStoredProcedure("UserDelete");
            dal.ClearParameters();
        }

        public static MDBUser CreateUser(string username, string password, string firstname, string lastname, UserType type)
        {
            try
            {
                MembershipUser u = Membership.CreateUser(username, password);
                DataAccessLayer dal = new DataAccessLayer();
                dal.AddParameter("@Username", username, DbType.String);
                dal.AddParameter("@Firstname", firstname, DbType.String);
                dal.AddParameter("@Lastname", lastname, DbType.String);
                dal.AddParameter("@UserType", type, DbType.Int16);
                //dal.AddParameter("@Executor", Membership.GetUser().UserName, DbType.String);
                dal.AddParameter("@Executor", Membership.GetUser() == null ? "370929" : Membership.GetUser().UserName, DbType.String); //Only to testing
                dal.ExecuteStoredProcedure("UserInsert");
                dal.ClearParameters();

                return new MDBUser(u, firstname, lastname);
            }
            catch (MembershipCreateUserException)
            {
                throw;
            }
        }

        public static MDBUser GetUser(string username)
        {
            MembershipUser u = Membership.GetUser(username);
            return u == null ? null : new MDBUser(u);
        }

        public static List<MDBUser> GetAllUsers()
        {
            List<MDBUser> result = new List<MDBUser>();

            foreach (MembershipUser user in Membership.GetAllUsers())
                result.Add(new MDBUser(user));

            return result;
        }

        public static List<MDBUser> GetAllUsersWithoutCurrent()
        {
            List<MDBUser> result = new List<MDBUser>();

            foreach (MembershipUser user in Membership.GetAllUsers())
                if (user != Membership.GetUser())
                    result.Add(new MDBUser(user));

            return result;
        }

        public enum UserType { Read = 0, Write = 1, Admin = 2 }
    }

    public class Employee
    {
        public int? Id { get; private set; }

        private string _manr;
        public string MANR
        {
            get { return _manr; }
            set { _manr = value.Trim(); }
        }

        private string _stabsnummer;
        public string Stabsnummer
        {
            get { return _stabsnummer; }
            set { _stabsnummer = value.Trim(); }
        }

        private string _name;
        public string Name
        {
            get { return _name; }
            set { _name = value.Trim(); }
        }
        public bool SignedSolemnDeclaration { get; set; }
        public string Notes { get; set; }

        public bool Save()
        {
            DataAccessLayer dal = new DataAccessLayer();

            dal.AddParameter("@MANR", MANR, DbType.String);
            dal.AddParameter("@Stabsnummer", Stabsnummer, DbType.String);
            dal.AddParameter("@Name", Name, DbType.String);
            dal.AddParameter("@SignedSolemnDeclaration", SignedSolemnDeclaration, DbType.Boolean);
            dal.AddParameter("@Notes", Notes ?? "", DbType.String);
            dal.AddParameter("@Executor", Membership.GetUser().UserName, DbType.String);

            if (Id == null)
            {
                dal.AddParameter("@LastId", Id, DbType.Int32, ParameterDirection.Output);
                dal.ExecuteStoredProcedure("EmployeeInsert");
                Id = Convert.ToInt32(dal.GetParameterValue("@LastId"));
                dal.ClearParameters();
                return Id != null;
            }
            else
            {
                dal.AddParameter("@Id", Id, DbType.Int32);
                dal.ExecuteStoredProcedure("EmployeeUpdate");
                dal.ClearParameters();
                return true;
            }
        }

        public static Employee GetEmployee(string manr)
        {
            return GetEmployee(null, manr);
        }

        public static Employee GetEmployee(int id)
        {
            return GetEmployee(id, null);
        }

        private static Employee GetEmployee(int? id, string manr)
        {
            DataAccessLayer dal = new DataAccessLayer();

            dal.AddParameter("@Id", (object)id ?? DBNull.Value, DbType.Int32);
            dal.AddParameter("@MANR", manr, DbType.String);
            DataTable dt = dal.ExecuteDataTable("SELECT * FROM [Employees] WHERE (@Id IS NULL OR [Id] = @Id) AND (@MANR IS NULL OR [MANR] = @MANR)");
            dal.ClearParameters();

            return (dt.Rows.Count != 1) ? null : new Employee
            {
                Id = (int)dt.Rows[0]["Id"],
                MANR = dt.Rows[0]["MANR"].ToString(),
                Stabsnummer = dt.Rows[0]["Stabsnummer"].ToString(),
                Name = dt.Rows[0]["Name"].ToString(),
                SignedSolemnDeclaration = (bool)dt.Rows[0]["SignedSolemnDeclaration"],
                Notes = dt.Rows[0]["Notes"].ToString()
            };
        }
    }

    public class Device : IEquatable<Device>
    {
        public int? Id { get; private set; }

        private string _imei;
        public string IMEI
        {
            get { return _imei; }
            set { _imei = value.Trim(); }
        }

        private string _model;
        public string Model
        {
            get { return _model; }
            set { _model = value.Trim(); }
        }

        private string _provider;
        public string Provider
        {
            get { return _provider; }
            set { _provider = value.Trim(); }
        }

        private string _orderNumber;
        public string OrderNumber
        {
            get { return _orderNumber; }
            set { _orderNumber = value.Trim(); }
        }
        public DateTime? BuyDate { get; set; }
        public int TypeId { get; set; }
        public string Type { get; private set; }
        public int UnitId { get; set; }
        public string Unit { get; private set; }
        public string Notes { get; set; }
        public string CurrentStatus { get; private set; }

        public bool Save()
        {
            DataAccessLayer dal = new DataAccessLayer();

            dal.AddParameter("@IMEI", IMEI, DbType.String);
            dal.AddParameter("@Model", Model, DbType.String);
            dal.AddParameter("@Provider", Provider, DbType.String);
            dal.AddParameter("@OrderNumber", OrderNumber, DbType.String);
            dal.AddParameter("@BuyDate", (object)BuyDate ?? DBNull.Value, DbType.Date);
            dal.AddParameter("@TypeRefId", TypeId, DbType.Int32);
            dal.AddParameter("@UnitRefId", UnitId, DbType.Int32);
            dal.AddParameter("@Notes", Notes ?? "", DbType.String);
            dal.AddParameter("@Executor", Membership.GetUser().UserName, DbType.String);
            dal.AddParameter("@Type", null, DbType.String, ParameterDirection.Output);
            dal.AddParameter("@Unit", null, DbType.String, ParameterDirection.Output);

            if (Id == null)
            {
                dal.AddParameter("@LastId", Id, DbType.Int32, ParameterDirection.Output);
                dal.ExecuteStoredProcedure("DeviceInsert");
                Id = Convert.ToInt32(dal.GetParameterValue("@LastId"));
                Type = dal.GetParameterValue("@Type").ToString();
                Unit = dal.GetParameterValue("@Unit").ToString();
                dal.ClearParameters();
                return Id != null;
            }
            else
            {
                dal.AddParameter("@Id", Id, DbType.Int32);
                dal.ExecuteStoredProcedure("DeviceUpdate");
                Type = dal.GetParameterValue("@Type").ToString();
                Unit = dal.GetParameterValue("@Unit").ToString();
                dal.ClearParameters();
                return true;
            }
        }
        
        public static List<Device> FindDevices(Employee employee)
        {
            List<Device> devices = new List<Device>();
            DataAccessLayer dal = new DataAccessLayer();

            dal.AddParameter("@EmployeeId", employee.Id, DbType.Int32);
            DataTable dt = dal.ExecuteDataTable("SELECT * FROM [DeviceView] WHERE ([EmployeeId] = @EmployeeId)");
            dal.ClearParameters();

            foreach (DataRow row in dt.Rows)
                devices.Add(CreateFromRow(row));

            return devices;
        }

        public static Device GetDevice(string imei) => GetDevice(null, imei);
        public static Device GetDevice(int id) => GetDevice(id, null);
        private static Device GetDevice(int? id, string imei)
        {
            DataAccessLayer dal = new DataAccessLayer();

            dal.AddParameter("@Id", (object)id ?? DBNull.Value, DbType.Int32);
            dal.AddParameter("@IMEI", imei, DbType.String);
            DataTable dt = dal.ExecuteDataTable("SELECT * FROM [DeviceView] WHERE (@Id IS NULL OR [Id] = @Id) AND (@IMEI IS NULL OR [IMEI] = @IMEI)");
            dal.ClearParameters();

            return (dt.Rows.Count != 1) ? null : CreateFromRow(dt.Rows[0]);
        }

        private static Device CreateFromRow(DataRow row)
        {
            return new Device
            {
                Id = (int)row["Id"],
                IMEI = row["IMEI"].ToString(),
                Model = row["Model"].ToString(),
                Provider = row["Provider"].ToString(),
                OrderNumber = row["OrderNumber"].ToString(),
                BuyDate = row["BuyDate"] == DBNull.Value ? null : (DateTime?)row["BuyDate"],
                TypeId = (int)row["TypeRefId"],
                Type = row["Type"].ToString(),
                UnitId = (int)row["UnitRefId"],
                Unit = row["Unit"].ToString(),
                Notes = row["Notes"].ToString(),
                CurrentStatus = $"{row["Status"]} {row["Stabsnummer"]} {row["Name"]}".Trim()
            };
        }

        public override string ToString() => IMEI;
        public override bool Equals(object obj) => Equals(obj is Device);
        public bool Equals(Device other) => other != null && EqualityComparer<int?>.Default.Equals(Id, other.Id);
        public override int GetHashCode() => 2108858624 + EqualityComparer<int?>.Default.GetHashCode(Id);
    }

    public class DeviceWithResult : Device
    {
        public string Result { get; set; }
    }

    public class Simcard : IEquatable<Simcard>
    {
        public int? Id { get; private set; }

        private string _simnumber;
        public string Simnumber
        {
            get { return _simnumber; }
            set { _simnumber = value.Trim(); }
        }

        private string _puk;
        public string PUK
        {
            get { return _puk; }
            set { _puk = value.Trim(); }
        }

        private string _number;
        public string Number
        {
            get { return _number; }
            set { _number = value.Trim(); }
        }

        public bool IsData { get; set; }

        public int FormatId { get; set; }
        public string Format { get; private set; }
        public int QuotaId { get; set; }
        public string Quota { get; private set; }
        public DateTime? QuotaEndDate { get; set; }
        public int DataPlanId { get; set; }
        public string DataPlan { get; private set; }

        private string _provider;
        public string Provider
        {
            get { return _provider; }
            set { _provider = value.Trim(); }
        }

        private string _orderNumber;
        public string OrderNumber
        {
            get { return _orderNumber; }
            set { _orderNumber = value.Trim(); }
        }
        public DateTime? BuyDate { get; set; }
        public int UnitId { get; set; }
        public string Unit { get; private set; }
        public string Notes { get; set; }
        public string CurrentStatus { get; private set; }

        public bool Save()
        {
            DataAccessLayer dal = new DataAccessLayer();

            dal.AddParameter("@Simnumber", Simnumber, DbType.String);
            dal.AddParameter("@PUK", PUK, DbType.String);
            dal.AddParameter("@Number", Number, DbType.String);
            dal.AddParameter("@IsData", IsData, DbType.Boolean);
            dal.AddParameter("@FormatRefId", FormatId, DbType.Int32);
            dal.AddParameter("@QuotaRefId", QuotaId, DbType.Int32);
            dal.AddParameter("@QuotaEndDate", (object)QuotaEndDate ?? DBNull.Value, DbType.Date);
            dal.AddParameter("@DataPlanRefId", DataPlanId, DbType.Int32);
            dal.AddParameter("@Provider", Provider, DbType.String);
            dal.AddParameter("@OrderNumber", OrderNumber, DbType.String);
            dal.AddParameter("@BuyDate", (object)BuyDate ?? DBNull.Value, DbType.Date);
            dal.AddParameter("@UnitRefId", UnitId, DbType.Int32);
            dal.AddParameter("@Notes", Notes ?? "", DbType.String);
            dal.AddParameter("@Executor", Membership.GetUser().UserName, DbType.String);
            dal.AddParameter("@Format", null, DbType.String, ParameterDirection.Output);
            dal.AddParameter("@Quota", null, DbType.String, ParameterDirection.Output);
            dal.AddParameter("@DataPlan", null, DbType.String, ParameterDirection.Output);
            dal.AddParameter("@Unit", null, DbType.String, ParameterDirection.Output);

            if (Id == null)
            {
                dal.AddParameter("@LastId", Id, DbType.Int32, ParameterDirection.Output);
                dal.ExecuteStoredProcedure("SimcardInsert");
                Id = Convert.ToInt32(dal.GetParameterValue("@LastId"));
                Format = dal.GetParameterValue("@Format").ToString();
                Quota = dal.GetParameterValue("@Quota").ToString();
                DataPlan = dal.GetParameterValue("@DataPlan").ToString();
                Unit = dal.GetParameterValue("@Unit").ToString();
                dal.ClearParameters();
                return Id != null;
            }
            else
            {
                dal.AddParameter("@Id", Id, DbType.Int32);
                dal.ExecuteStoredProcedure("SimcardUpdate");
                Format = dal.GetParameterValue("@Format").ToString();
                Quota = dal.GetParameterValue("@Quota").ToString();
                DataPlan = dal.GetParameterValue("@DataPlan").ToString();
                Unit = dal.GetParameterValue("@Unit").ToString();
                dal.ClearParameters();
                return true;
            }
        }
        
        public static List<Simcard> FindSimcards(Employee employee)
        {
            List<Simcard> simcards = new List<Simcard>();
            DataAccessLayer dal = new DataAccessLayer();

            dal.AddParameter("@EmployeeId", employee.Id, DbType.Int32);
            DataTable dt = dal.ExecuteDataTable("SELECT * FROM [SimcardView] WHERE ([EmployeeId] = @EmployeeId)");
            dal.ClearParameters();

            foreach (DataRow row in dt.Rows)
                simcards.Add(CreateFromRow(row));

            return simcards;
        }
        public static Simcard GetSimcard(string simnumber) => GetSimcard(null, simnumber);
        public static Simcard GetSimcard(int id) => GetSimcard(id, null);
        private static Simcard GetSimcard(int? id, string simnumber)
        {
            DataAccessLayer dal = new DataAccessLayer();

            dal.AddParameter("@Id", (object)id ?? DBNull.Value, DbType.Int32);
            dal.AddParameter("@Simnumber", simnumber, DbType.String);
            DataTable dt = dal.ExecuteDataTable("SELECT * FROM [SimcardView] WHERE (@Id IS NULL OR [Id] = @Id) AND (@Simnumber IS NULL OR [Simnumber] = @Simnumber)");
            dal.ClearParameters();

            return (dt.Rows.Count != 1) ? null : CreateFromRow(dt.Rows[0]);
        }

        private static Simcard CreateFromRow(DataRow row)
        {
            return new Simcard
            {
                Id = (int)row["Id"],
                Simnumber = row["Simnumber"].ToString(),
                PUK = row["PUK"].ToString(),
                Number = row["Number"].ToString(),
                IsData = (bool)row["IsData"],
                FormatId = (int)row["FormatRefId"],
                Format = row["Format"].ToString(),
                QuotaId = (int)row["QuotaRefId"],
                Quota = row["Quota"].ToString(),
                QuotaEndDate = row["QuotaEndDate"] as DateTime?,
                DataPlanId = (int)row["DataPlanRefId"],
                DataPlan = row["DataPlan"].ToString(),
                Provider = row["Provider"].ToString(),
                OrderNumber = row["OrderNumber"].ToString(),
                BuyDate = row["BuyDate"] as DateTime?,
                UnitId = (int)row["UnitRefId"],
                Unit = row["Unit"].ToString(),
                Notes = row["Notes"].ToString(),
                CurrentStatus = $"{row["Status"]} {row["Stabsnummer"]} {row["Name"]}".Trim()
            };
        }

        public override string ToString() => Simnumber;
        public override bool Equals(object obj) => Equals(obj as Simcard);
        public bool Equals(Simcard other) => other != null && EqualityComparer<int?>.Default.Equals(Id, other.Id);
        public override int GetHashCode() => 2108858624 + EqualityComparer<int?>.Default.GetHashCode(Id);
    }

    public class SimcardWithResult : Simcard
    {
        public string Result { get; set; }
    }

    public class MusterLine
    {
        public int Line { get; set; }
        public MusterLinePart MANR { get; set; }
        public MusterLinePart Stabsnummer { get; set; }
        public MusterLinePart Name { get; set; }
        public Employee Employee { get; set; }
        public MusterLinePart IMEI { get; set; }
        public Device Device { get; set; }
        public MusterLinePart SIMnumber { get; set; }
        public Simcard Simcard { get; set; }
        public KeyValuePair<int, string> TaxType { get; set; }
        public MusterLine(int line, string manr, string stabsnummer, string name, string imei, string simnumber, KeyValuePair<int, string> taxType)
        {
            Line = line;

            manr = manr.Trim();
            if (manr.Length == 8 && manr.StartsWith("00"))
                manr = manr.Substring(2);

            stabsnummer = stabsnummer.ToUpper();

            imei = GetNumbers(imei);
            simnumber = GetNumbers(simnumber);

            MANR = new MusterLinePart(manr);
            Stabsnummer = new MusterLinePart(stabsnummer.Trim());
            Name = new MusterLinePart(name.Trim());
            Employee = Employee.GetEmployee(manr);
            IMEI = new MusterLinePart(imei);
            Device = Device.GetDevice(imei);
            SIMnumber = new MusterLinePart(simnumber);
            Simcard = Simcard.GetSimcard(simnumber);
            TaxType = taxType;

            if (Employee != null)
            {
                Stabsnummer.DBPart = Employee.Stabsnummer;
                Name.DBPart = Employee.Name;
            }
        }

        private string GetNumbers(string input)
        {
            return new Regex(@"[\D]").Replace(input, "");
        }

        public class MusterLinePart
        {
            private string _inputPart = "";
            private string _dBPart = "";
            private string _message = "";

            public string InputPart { get => _inputPart; set => _inputPart = value; }
            public string DBPart { get => _dBPart; set => _dBPart = value; }
            public string Message { get => _message; set => _message = value; }
            public MusterLinePart(string inputPart) => _inputPart = inputPart;

            public bool IsGood() => (InputPart == DBPart
                || (_inputPart == "" && _dBPart != "")
                || (_inputPart != "" && _dBPart == ""))
                && _message == "";

            public override string ToString()
            {
                return _dBPart != "" ? _dBPart : _inputPart;
            }

            public override bool Equals(object obj) => obj is MusterLinePart m && m.InputPart == this.InputPart;

            public override int GetHashCode()
            {
                var hashCode = -434218392;
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(InputPart);
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(DBPart);
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(Message);
                return hashCode;
            }
        }
    }
}