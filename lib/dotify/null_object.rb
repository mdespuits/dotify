class NullObject
  def method_missing name, *args, &blk
    self
  end
  def nil?;     true;   end
  def present?; !nil?;  end
  def to_a;     [];     end
  def to_ary;   [];     end
  def to_s;     '';     end
  def to_i;     0;      end
  def to_f;     0.0;    end
end