<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Editor.aspx.cs" Inherits="tvSeries.Admin.Editor" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" runat="server" href="/Styles/Admin/Editor.css" />
    <script runat="server">

        public bool isUpdate = false;
        public int id = 0;

        private static Random random = new Random();
        public static string RandomString(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[random.Next(s.Length)]).ToArray());
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.QueryString["id"] != null)
            {
                if (!Page.IsPostBack)
                {
                    isUpdate = true;
                    id = int.Parse(Request.QueryString["id"].ToString());
                    GetPostDetail();
                }

            }

        }

        protected void GetPostDetail()
        {
            SqlConnection conn =
                 new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=tvseries; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "SELECT * FROM tvseries.dbo.Series WHERE id = @Id";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("Id", id);

            try
            {
                conn.Open();

                SqlDataReader rd = command.ExecuteReader();

                while (rd.Read())
                {
                    TitleTextBox.Text = rd["title"].ToString();
                    GenreTextBox.Text = rd["genre"].ToString();
                    YearTextBox.Text = rd["year"].ToString();
                    StoryTextBox.Text = rd["story"].ToString();

                }

            }
            catch (Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }
        }


        protected void PostAction(object sender, EventArgs e)
        {

            String uploadedFileNames = "";

            SqlConnection conn =
                 new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=tvseries; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "INSERT INTO tvseries.dbo.Series (title, genre, year, trailerImage, story) VALUES (@Title, @Genre, @Year, @TrailerImage, @Story)";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@Title", TitleTextBox.Text.ToString());
            command.Parameters.AddWithValue("@Genre", GenreTextBox.Text.ToString());
            command.Parameters.AddWithValue("@Year", YearTextBox.Text.ToString());
            command.Parameters.AddWithValue("@Story", StoryTextBox.Text.ToString());

            if (TrailerImageUploader.HasFiles)
            {
                try
                {
                    int i = 0;
                    foreach (var item in TrailerImageUploader.PostedFiles)
                    {
                        String extension = Path.GetExtension(TrailerImageUploader.PostedFiles[i].FileName);

                        if (extension == ".jpg" || extension == ".png" || extension == ".jpeg")
                        {
                            String FileName = Path.GetFileName(TrailerImageUploader.PostedFiles[i].FileName);
                            String randStr = RandomString(30);
                            uploadedFileNames += (randStr + extension + ",");
                            TrailerImageUploader.PostedFiles[i].SaveAs(Server.MapPath("~/Uploads//") + randStr + extension);
                        }
                        else
                        {
                            TrailerErrorLabel.Text = "지원되지 않는 확장자입니다.";
                            TrailerErrorLabel.Visible = true;
                            return;
                        }

                        i++;
                    }

                }
                catch (Exception exception)
                {
                    Response.Write(exception.Message.ToString());
                }

            }
            else
            {
                TrailerErrorLabel.Text = "반드시 한개 이상의 이미지를 업로드해야합니다.";
                TrailerErrorLabel.Visible = true;
                return;
            }

            command.Parameters.AddWithValue("@TrailerImage", uploadedFileNames);

            try
            {
                conn.Open();
                command.ExecuteNonQuery();
            }
            catch (Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }

            Response.Redirect("/Admin/AdminHome.aspx");
        }

        protected void RemovePost(object sender, EventArgs e)
        {
            SqlConnection conn =
                 new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=tvseries; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "DELETE FROM tvseries.dbo.Series WHERE id = @Id";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@Id", int.Parse(Request.QueryString["id"].ToString()));

            try
            {
                conn.Open();

                String uploadedImages = "";
                String ExistingSQL = "SELECT * FROM tvseries.dbo.Series WHERE id = " + int.Parse(Request.QueryString["id"].ToString());
                SqlCommand existingCommand = new SqlCommand(ExistingSQL, conn);

                SqlDataReader rd = existingCommand.ExecuteReader();
                while (rd.Read())
                {
                    uploadedImages = rd["trailerImage"].ToString();
                }
                rd.Close();

                String[] uploadedArr = uploadedImages.Split(',');

                for (int k = 0; k < uploadedArr.Length - 1; k++)
                {
                    if (File.Exists(Server.MapPath("~/Uploads//") + uploadedArr[k]))
                    {
                        File.Delete(Server.MapPath("~/Uploads//") + uploadedArr[k]);
                    }
                }

                command.ExecuteNonQuery();

            }
            catch (Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }

            Response.Redirect("/Admin/AdminHome.aspx");
        }

        protected void UpdatePost(object sender, EventArgs e)
        {
            String uploadedFileNames = "";

            SqlConnection conn =
                 new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=tvseries; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "UPDATE tvseries.dbo.Series SET title = @Title, genre = @Genre, year = @Year, trailerImage = @TrailerImage, story = @Story WHERE id = @Id";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@Title", TitleTextBox.Text.ToString());
            command.Parameters.AddWithValue("@Genre", GenreTextBox.Text.ToString());
            command.Parameters.AddWithValue("@Year", YearTextBox.Text.ToString());
            command.Parameters.AddWithValue("@Story", StoryTextBox.Text.ToString());
            command.Parameters.AddWithValue("@Id", int.Parse(Request.QueryString["id"].ToString()));

            try
            {
                conn.Open();



                if (TrailerImageUploader.HasFiles)
                {
                    try
                    {
                        String uploadedImages = "";
                        String ExistingSQL = "SELECT * FROM tvseries.dbo.Series WHERE id = " + int.Parse(Request.QueryString["id"].ToString());
                        SqlCommand existingCommand = new SqlCommand(ExistingSQL, conn);

                        SqlDataReader rd = existingCommand.ExecuteReader();
                        while (rd.Read())
                        {
                            uploadedImages = rd["trailerImage"].ToString();
                        }
                        rd.Close();

                        String[] uploadedArr = uploadedImages.Split(',');

                        for (int k = 0; k < uploadedArr.Length - 1; k++)
                        {
                            if (File.Exists(Server.MapPath("~/Uploads//") + uploadedArr[k]))
                            {
                                File.Delete(Server.MapPath("~/Uploads//") + uploadedArr[k]);
                            }
                        }

                        int i = 0;
                        foreach (var item in TrailerImageUploader.PostedFiles)
                        {
                            String extension = Path.GetExtension(TrailerImageUploader.PostedFiles[i].FileName);

                            if (extension == ".jpg" || extension == ".png" || extension == ".jpeg")
                            {
                                String FileName = Path.GetFileName(TrailerImageUploader.PostedFiles[i].FileName);
                                String randStr = RandomString(30);
                                uploadedFileNames += (randStr + extension + ",");
                                TrailerImageUploader.PostedFiles[i].SaveAs(Server.MapPath("~/Uploads//") + randStr + extension);
                            }
                            else
                            {
                                TrailerErrorLabel.Text = "지원되지 않는 확장자입니다.";
                                TrailerErrorLabel.Visible = true;
                                isUpdate = true;
                                return;
                            }

                            i++;
                        }

                    }
                    catch (Exception exception)
                    {
                        Response.Write(exception.Message.ToString());
                    }

                }
                else
                {
                    TrailerErrorLabel.Text = "반드시 한개 이상의 이미지를 업로드해야합니다.";
                    TrailerErrorLabel.Visible = true;
                    isUpdate = true;
                    return;
                }

                command.Parameters.AddWithValue("@TrailerImage", uploadedFileNames);

                try
                {

                    command.ExecuteNonQuery();
                }
                catch (Exception exception)
                {
                    Response.Write(exception.Message.ToString());
                }
                finally
                {
                    conn.Close();
                }


                Response.Redirect("/Admin/AdminHome.aspx");


            }
            catch (Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="EditorForm">
        <div class="Content">
            <div class="Line">
                <div class="Label">
                    시리즈 제목
                </div>
                <asp:RequiredFieldValidator runat="server" CssClass="ErrorMessage" ErrorMessage="제목을 입력해주세요" ID="TitleValidotor" ControlToValidate="TitleTextBox" Display="Dynamic" />
                <div class="InputWrapper">
                    <asp:TextBox runat="server" ID="TitleTextBox" CssClass="Input"></asp:TextBox>
                </div>
            </div>
            <div class="Line">
                <div class="Label">
                    시리즈 장르 (/로 구분)
                </div>
                <asp:RequiredFieldValidator runat="server" CssClass="ErrorMessage" ErrorMessage="장르를 입력해주세요" ID="GenreValidator" ControlToValidate="GenreTextBox" Display="Dynamic" />
                <div class="InputWrapper">
                    <asp:TextBox runat="server" ID="GenreTextBox" CssClass="Input"></asp:TextBox>
                </div>
            </div>
            <div class="Line">
                <div class="Label">
                    방영 연도 (yyyy-yyyy)
                </div>
                <asp:RequiredFieldValidator runat="server" CssClass="ErrorMessage" ErrorMessage="방영 연도를 입력해주세요" ID="YearValidator" ControlToValidate="YearTextBox" Display="Dynamic" />

                <div class="InputWrapper">
                    <asp:TextBox runat="server" ID="YearTextBox" CssClass="Input"></asp:TextBox>
                </div>
            </div>
            <div class="Line">
                <div class="Label">
                    트레일러 이미지 <%if (isUpdate)
                                 { %>
                        (수정시 모든 이미지는 초기화됩니다.)
                    <%} %>
                </div>
                <asp:Label CssClass="ErrorMessage" ID="TrailerErrorLabel" runat="server" Visible="false"></asp:Label>
                <div class="InputWrapper">
                    <asp:FileUpload runat="server" AllowMultiple="true" ID="TrailerImageUploader" CssClass="Input"></asp:FileUpload>
                </div>
            </div>
            <div class="Line">
                <div class="Label">
                    줄거리
                </div>
                <asp:RequiredFieldValidator runat="server" CssClass="ErrorMessage" ErrorMessage="줄거리를 입력해주세요" ID="StoryValidator" ControlToValidate="StoryTextBox" Display="Dynamic" />
                <div class="InputWrapper">
                    <asp:TextBox runat="server" Columns="10" ID="StoryTextBox" TextMode="MultiLine" CssClass="TextArea"></asp:TextBox>
                </div>
            </div>
            <div class="ButtonWrapper">
                <% if (isUpdate)
                    { %>
                <asp:Button ID="UpdateButton" OnClick="UpdatePost" Text="수정하기" CssClass="Button" runat="server" />
                <asp:Button ID="RemoveButton" OnClick="RemovePost" Text="삭제하기" CssClass="DeleteButton" runat="server" />
                <%}
                    else
                    { %>
                <asp:Button ID="PostButton" OnClick="PostAction" Text="포스팅하기" CssClass="Button" runat="server" />
                <%} %>
            </div>
        </div>
    </div>
</asp:Content>
