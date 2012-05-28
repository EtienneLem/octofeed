# http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-time_ago_in_words
def time_ago_in_words(from_time, include_seconds = false)
  distance_of_time_in_words(from_time, Time.now, include_seconds)
end

# http://api.rubyonrails.org/classes/ActionView/Helpers/DateHelper.html#method-i-distance_of_time_in_words
def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false, options = {})
  from_time = from_time.to_time if from_time.respond_to?(:to_time)
  to_time = to_time.to_time if to_time.respond_to?(:to_time)
  distance_in_minutes = (((to_time - from_time).abs)/60).round
  distance_in_seconds = ((to_time - from_time).abs).round

  case distance_in_minutes
    when 0..1
      return distance_in_minutes == 0 ?
             "less than 1 minute" :
             "#{distance_in_minutes} minutes" unless include_seconds

      case distance_in_seconds
        when 0..4   then "less than 5 seconds"
        when 5..9   then "less than 10 seconds"
        when 10..19 then "less than 20 seconds"
        when 20..39 then "half a minute"
        when 40..59 then "less than a minute"
        else             "a minute"
      end

    when 2..44           then "#{distance_in_minutes} minutes"
    when 45..89          then "an hour"
    when 90..1439        then "#{(distance_in_minutes.to_f / 60.0).round} hours"
    when 1440..2519      then "a day"
    when 2520..43199     then "#{(distance_in_minutes.to_f / 1440.0).round} days"
    when 43200..86399    then "a month"
    when 86400..525599   then "#{(distance_in_minutes.to_f / 43200.0).round} months"
    else
      fyear = from_time.year
      fyear += 1 if from_time.month >= 3
      tyear = to_time.year
      tyear -= 1 if to_time.month < 3
      leap_years = (fyear > tyear) ? 0 : (fyear..tyear).count{|x| Date.leap?(x)}
      minute_offset_for_leap_year = leap_years * 1440
      # Discount the leap year days when calculating year distance.
      # e.g. if there are 20 leap year days between 2 dates having the same day
      # and month then the based on 365 days calculation
      # the distance in years will come out to over 80 years when in written
      # english it would read better as about 80 years.
      minutes_with_offset         = distance_in_minutes - minute_offset_for_leap_year
      remainder                   = (minutes_with_offset % 525600)
      distance_in_years           = (minutes_with_offset / 525600)
      if remainder < 131400
        if distance_in_years == 1
          "about a year"
        else
          "about #{distance_in_years} years"
        end
      elsif remainder < 394200
        if distance_in_years == 1
          "over a year"
        else
          "over #{distance_in_years} years"
        end
      else
        if distance_in_years + 1 == 1
          "almost a year"
        else
          "almost #{distance_in_years} years"
        end
      end
  end
end

# Link to `https://github.com/params`
def gh_link(params)
  "<a href=\"https://github.com/#{params}\">#{params}</a>"
end

# Link to an issue/pull comment
def gh_issue_comment_link(url, comment_id, issue_number, is_pull)
  type = 'issue'
  if is_pull
    url = url.gsub('/issues/', '/pull/')
    type = 'pull request'
  end

  "<a href=\"#{url}#issuecomment-#{comment_id}\">#{type} #{issue_number}</a>"
end

# Link to a gist
def gh_gist_link(id, url)
  "<a href=\"#{url}\">gist: #{id}</a>"
end

# Link to a sha
def gh_sha_link(repo, sha)
  "<a href=\"https://github.com/#{repo}/commit/#{sha}\">#{sha[0..6]}</a>"
end

# Link to a branch/tag
def gh_tree_link(repo, tree_node)
  "<a href=\"https://github.com/#{repo}/tree/#{tree_node}\">#{tree_node}</a>"
end

# Link to a file comment
def gh_commit_comment_link(repo, comment_id, commit_id)
  "<a href=\"https://github.com/#{repo}/commit/#{commit_id}#commitcomment-#{comment_id}\">#{commit_id[0..9]}</a>"
end