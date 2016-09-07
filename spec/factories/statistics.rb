FactoryGirl.define do
  factory :statistic do
    key 'key'
    value '1.23'
    iteration_index 1

    factory :statistic_precision do
       key 'precision'
       value '0.6284480772625486'
    end

    factory :statistic_recall do
      key 'recall'
      value '0.3800804335583704'
    end

    factory :statistic_f1_score do
      key 'f1_score'
      value '0.4736818346968625'
    end

    factory :statistic_num_annotations do
      key 'num_annotations'
      value '4'
    end
  end
end
