module PlayersHelper
  def ranking(player)
    content_tag(:div, class: 'label label-important ranking') do
      (player.ranking.to_s + trend(player)).html_safe
    end
  end

  def trend(player)
    case player.trend
    when :up
      content_tag(
        :a,
        content_tag(:i, '', class: 'icon-chevron-up'),
        title: I18n.t('trend.improving'),
        class: 'tooltip trend'
      )
    when :down
      content_tag(
        :a,
        content_tag(:i, '', class: 'icon-chevron-down'),
        title: I18n.t('trend.worsening'),
        class: 'tooltip trend'
      )
    else
      ''
    end
  end

  def image_for(player)
    return 'https://travisrhancock.files.wordpress.com/2014/08/ping-pong.jpg' unless player.image_url
    player.image_url
  end

  def level_image_for(player)
    if player.rating < LEVEL_1_MAX_POINTS
      '/assets/images/badge-newbie.png'
    elsif player.rating < LEVEL_2_MAX_POINTS
      '/assets/images/badge-badass.png'
    elsif player.rating < LEVEL_3_MAX_POINTS
      '/assets/images/badge-ninja.png'
    elsif player.rating < LEVEL_4_MAX_POINTS
      '/assets/images/badge-respect.png'
    else
      '/assets/images/badge-respect.png'
    end
  end

  def level_image_tag_for(player)
    level_image_for(player).gsub('/assets/images/', '')
  end

  def distance_of_last_game_for(player)
    last_game = player.games.order('updated_at DESC').first

    return unless last_game
    element = content_tag(
      :span,
      distance_of_time_in_words_to_now(last_game.updated_at),
      title: last_game.updated_at.strftime('%c')
    )
    I18n.t('player.game_last_played', distance: element).html_safe
  end

  def link_to_primary_action_for(player)
    if current_player == player
      link_to edit_player_path(player), class: 'link' do
        content_tag(:i, '', class: ' ') + I18n.t('player.edit.link')
      end
    elsif current_player && current_player.in_progress_games(player).present?
      enter_score_options = {
        remote: true,
        data: { disable_with: I18n.t('game.complete.link_loading') },
        class: 'btn btn-with-loading'
      }

      link_to new_game_score_path(current_player.in_progress_games(player).first), enter_score_options do
        content_tag(:i, '', class: 'icon-plus-sign icon-white') + I18n.t('game.complete.link')
      end
    elsif current_player
      challenge_link_options = {
        method: :post,
        remote: true,
        data: { disable_with: I18n.t('game.new.link_loading') },
        class: 'btn btn-with-loading challenge'
      }

      link_to games_path(game: { challenged_id: player.id }), challenge_link_options do
        content_tag(:i, '', class: 'icon-screenshot icon-white') + I18n.t('game.new.link')
      end
    end
  end
end
