class TumblrEngine < RSOAuthEngine

  attr_accessor :delegate
  attr_reader :screen_name

  def initWithDelegate(delegate, consumerKey:consumerKey, consumerSecret:consumerSecret)
    if self.initWithHostName('www.tumblr.com', customHeaderFields:nil, signatureMethod:RSOAuthHMAC_SHA1, consumerKey:consumerKey, consumerSecret:consumerSecret)
      @screen_name = nil
      @delegate = delegate
      retrieveOAuthTokenFromKeychain
    end
    self
  end

  def removeOAuthTokenFromKeychain
    Lockbox.setArray([], forKey:'GymnastOauthInfo')
  end

  def storeOAuthTokenInKeychain
    ary = [self.token, self.tokenSecret]
    Lockbox.setArray(ary, forKey:'GymnastOauthInfo')
  end

  def retrieveOAuthTokenFromKeychain
    ret = Lockbox.arrayForKey('GymnastOauthInfo')
    if !ret.nil? and !ret.empty?
      setAccessToken(ret[0], secret:ret[1])
    end
  end

  def authenticateWithCompletionBlock(completionBlock)
    resetOAuthToken

    @oAuthCompletionBlock = completionBlock

    delegate.tumblrEngine(self, statusUpdate:"Waiting for user authorization...")
    delegate.tumblrEngineNeedsAuthentication(self)
  end

  def authenticateWithUsername(username, password:password)
    post_params = { 'x_auth_username' => username,
      'x_auth_password' => password,
      'x_auth_mode' => 'client_auth' }

    op = operationWithPath('oauth/access_token', params:post_params, httpMethod:'POST', ssl:true)

    op.onCompletion(lambda { |completedOperation|
      fillTokenWithResponseBody(completedOperation.responseString, type:RSOAuthAccessToken)
      @screen_name = username
      storeOAuthTokenInKeychain

      if @oAuthCompletionBlock
        @oAuthCompletionBlock.call(completedOperation)
      end

      @oAuthCompletionBlock = nil
    }, onError:lambda { |error|
      if @oAuthCompletionBlock
        @oAuthCompletionBlock.call(error)
      end

      @oAuthCompletionBlock = nil
    })

    delegate.tumblrEngine(self, statusUpdate:'Authenticating...')
    enqueueSignedOperation(op)
  end

  def cancelAuthentication
    ui = { NSLocalizedDescriptionKey => 'Authentication cancelled.' }
    error = NSError.errorWithDomain('net.shiftrefresh.TumblrEngine.ErrorDomain', code:401, userInfo:ui)

    if @oAuthCompletionBlock
      @oAuthCompletionBlock.call(error)
    end

    @oAuthCompletionBlock = nil
  end

  def forgetStoredToken
    removeOAuthTokenFromKeychain
    resetOAuthToken
    @screen_name = nil
  end

  def getDashboardEntries(completionBlock, onError:errorBlock)
    params = {}
    op = operationWithURLString(urlWithPath("/user/dashboard"), params:params, httpMethod:'GET')
    op.onCompletion(completionBlock, onError:errorBlock)
    enqueueSignedOperation(op)
  end

  def getBlogEntries(blog, onComplete:completionBlock, onError:errorBlock)
    params = {'api_key' => consumerKey}
    op = operationWithURLString(urlWithPath("/blog/#{blog}/posts"), params:params, httpMethod:'GET')
    op.onCompletion(completionBlock, onError:errorBlock)
    enqueueOperation(op)
  end

  def urlWithPath(path)
    'http://api.tumblr.com/v2' + path
  end

end
