class AdGenerator
  def initialize(images)
    @images = images;
  end
  private
  def enough_images?(rows, cols)
    total_images = rows * cols;
    if total_images > @images.size then
      puts "Not enough images to produce a #{rows} x #{cols} image.
        rows x columns cannot exceed #{@images.size}. Requested size requires
        #{rows * cols} images";
      return false;
    else
      return true;
    end
  end
  public
  def generate_ad(rows, cols, save_path = nil)
    if(enough_images?(rows, cols)) then
      images = @images;
      ad = Magick::ImageList.new;
      1.upto(rows) do
        image_list = Magick::ImageList.new;
        1.upto(cols) do
            image = Magick::Image.read(images.shift()).first
            image_list.push(image);
        end
        ad.push(image_list.append(false));
      end
      if save_path.nil? then
        return ad.append(true);
      else
        ad.append(true).write(save_path);
      end
    end
  end
end