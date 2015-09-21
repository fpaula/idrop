class Admin::CandidatesController < ApplicationController
  before_action :set_candidate, only: [:show, :edit, :update, :destroy]

  # GET /candidates
  # GET /candidates.json
  def index
    @candidates = Candidate.from_category(params[:category_id]).all
    @categories = Category.all.map{ |c| [c.name, c.id] }
    @current_category = params[:category_id]
  end

  # GET /candidates/1
  # GET /candidates/1.json
  def show
  end

  # GET /candidates/new
  def new
    @candidate = Candidate.new
    @categories = Category.all.map{ |c| [c.name, c.id] }
    @category = @candidate.try(:categories).try(:first).try(:id)
    @creative_commons = CreativeCommons.licenses.map { |version, url| [version, version] }
  end

  # GET /candidates/1/edit
  def edit
  end

  # POST /candidates
  # POST /candidates.json
  def create
    @candidate = Candidate.new(candidate_params)

    respond_to do |format|
      if @candidate.save
        set_candidate_categories
        CandidateCombination.recombine_candidates(category)

        format.html { redirect_to [:admin, @candidate], notice: 'Candidate was successfully created.' }
        format.json { render :show, status: :created, location: @candidate }
      else
        format.html { render :new }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /candidates/1
  # PATCH/PUT /candidates/1.json
  def update
    respond_to do |format|
      if @candidate.update(candidate_params)
        set_candidate_categories

        format.html { redirect_to [:admin, @candidate], notice: 'Candidate was successfully updated.' }
        format.json { render :show, status: :ok, location: @candidate }
      else
        format.html { render :edit }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidates/1
  # DELETE /candidates/1.json
  def destroy
    category = @candidate.category
    @candidate.destroy
    CandidateCombination.recombine_candidates(category)

    respond_to do |format|
      format.html { redirect_to candidates_url, notice: 'Candidate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate
    @candidate = Candidate.find(params[:id])
    @categories = Category.all.map{ |c| [c.name, c.id] }
    @creative_commons = CreativeCommons.licenses.map { |version, url| [version, version] }
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def candidate_params
    params.require(:candidate).permit(:name, :status, :image_url, :image_original_title, :image_original_url, :image_author_name, :image_author_url, :image_license, :modified_image)
  end

  def set_candidate_categories
    if category = Category.find(params['category']['category_id'])
      @candidate.categories << category
    else
      @candidate.categories.delete_all
    end
  end
end