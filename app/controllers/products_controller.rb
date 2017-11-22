class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :check_weixin_legality, only: [:weixin]
  # GET /products
  # GET /products.json
  def weixin
    if check_weixin_legality
      @echostr = params[:echostr]
      render plain: @echostr
    else
      render :text => "Forbidden", :status => 403
    end
  end

  def receive_message

    @message = params[:message]
    render plain: "大山的回应" +@message
  end
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price)
    end
    # 根据参数校验请求是否合法，如果非法返回错误页面
    # def check_weixin_legality
    #   array = [Rails.configuration.weixin_token, params[:timestamp], params[:nonce]].sort
    #   render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
    # end
    def check_weixin_legality
      array = [Rails.configuration.weixin_token, params[:timestamp], params[:nonce]].sort
      if params[:signature] != Digest::SHA1.hexdigest(array.join)
        return false
      else
        return true
      end
    end
end
