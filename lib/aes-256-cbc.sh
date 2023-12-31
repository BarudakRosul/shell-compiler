#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝeq�K��2c�'<:Q�J�4�c����u{������x��g�ё��\��<3ܺ?��g�GA��G��� �-rp�/����	�ӢJ�^���j݇׾X� �}���9������!'����N"^1�@�4�'��>�I���g��(4W��9��������_��Ӫ��L�\Je)�nBf�Yb���r���9F����!��9݅������]�u������J���8��,+��N���mE����Qe�]	��/���t�Oi�a����B��ϼ&׫�]�l�7#y�,-ݩ�nj���ׅ�x�Bঘ��G-�OTF�z�q�/@���@"�kv�\m������I�Q�U�e_PV�	Q6��йM�/Ϫぷ���9O�{��a���@����Z�M����3x�Շ�Pzf!���o�lB����|�s��w�|�Mę�[��K�[εB*lIDg����`y��G,\��7ι\����b���Q���4$����p�����ءG�u�=�Q�'�𖌄^t��1kMhnx���p�ڐ���ODI`vx��>G���	e�����kU�!i :P{��4�*^���)������|�h+��HUu���N{գriߒ�O!�3K>�� �����Њ^�O�*>��d�C���׀��`q�ۢ�E��nw�T���K�k">4��i�M-滒F�
���&,0���aܹ��8K1ͯ����1�P^Q�T�-�jeJH��������ԅ��XQp�*�g�Zd��>�ב>Wu��U3:��/����G�V�����ӛm40��ٽƳC˓� =�4� .���_�W��D��
��C����{�A���ڤ&�H�
�B,:a��O`��s�v�l���]�͢���)��ۋ�����b[%P�ϲ&�-)뫙��H��-�*��T�H�Yځ�`zi�ג�����4w�P��^�t���5x�3X�ǉ�q��5T�1�1�_�,�	A�w!ʡ3� ^��lփ�ыd5j���׵�l��ҝy� cd�i#L�{�ǡ��	�m�3���y�d#T�G��s�~�{zf(����gU-��Fe2˙�Rvs?i$�@ �B�R��ނt��IMK��aA���>�0�{S��x���bѯfEi�w>��`)��<�>O.���zx4>\�bЌ�U>���RA�!���u�K�3I����"A��q�M�݇��3=�UGN��l&�MJ��li���.��h��"�#��H3��̟4�cz��l,�Tz��*)B�0�a����� =�?<�m�С]E� �
Ŭ?by���8�DU*G��yF��c-NKE�Mf�Z����F�_���{T_W������!��&GRh��g�>	i��GCڟ(>N��K���2�}?��l�lEq��c3��݊
⠱�s���4t�����:��-l�bM�y'm����7-G"rQ=�V�Ҝ�@�O�4/r�۳u~4(�ɻΏ�Ë�Bt;��4D��<.�aP=�ݍ�<�[�:���X[)m�������SLͽ
$��?�u]O�ö���SR�|Kn�4�o��Sevk��/�˹\�����o�kM�w4"[%6i�v_Zz��Z�I����ݔ=N٨���pP�j+����&@�l��N�X"��-��,뜻���,�c��T�1\V�<{���Y	ݕ<����$}�6ͺš�_Whߊ��H�GRH�{A����T)+�5��}��sUϱ��w\_1*��}��G��\�A����52�m�k�Q(8��<�=;�cU`�����o�?A%q�j�s��@��(��P�J�\|E��Y�{x����S�{ɰs ���H�',��iZ0�|��\>����5�W����d�`��<H���>�WB�����c�e�>�~�=��W���wqޅ6G��f�|ٝ#n��5S��3Wb6�찌��@j/�pՇ���9��h��!�?���z�^�Fc�B�N#�]�A̿_�٩���ی�snVs��1�I�0{���s�4[J��ۍ�쬎��p����8�V�PlYvs��^],E���Xn����h���@�R!+�6��|� ����y[�/�=���T��K�f��<h�T���?V����z�O(��=�>�Ia:��{(����t��e~VM!r.`�����	ѝ[1j"��XBR���I���$`�LJ�,��E��MO:{��'c����q�պ�/9UM���fj3yGD�ʷ��B������'c�	���
��e��{�b���T�b%��	�m��%W栒)�FS�3?+�IY������ߢ��d����m(��l�&��G��^��_Ƈ�BJ�Z$�����+ńw �����Ys��ڀ��
|�xdҿ��f�l�k"2�a���2��H�������Qrq�䑟"Y>��$����D4�BY�1���Җ�k�	�VΝ�S8O:����k��z��sL6s���B�|��1ܗ�JT�wnN�`�؋�i���1��
�vع��&����6���
�Y�RH8eH(�e|�z�_ѼdpY��M �¨a����m� �>`��,�؃��Nexş� ��t��3�Ν�b�ja��\6C�dt�	|� !"6�N�/�YO�5i��
��gĄwv2]��SX�.,��ٿe�����5��g]��m���)���H�0�~�L�K������l�p�z�����6�7��;�	kN�k�|����f�y˲�|V4����@C�d6�!�9����V7ȐM)��9���Τ�t:[�#?�/�X��T^�Q5=��t5�	��?%h��`,]�lY�}Z?� �_�_����W��&�%d�@y���*��U+w/Y���9�N�
_���{�Vx�!,e�<<F3��}`�:
a�1N�7*�yC}�%��,��K}h���m}�C#�.�:g��X�4i���4 ������䧠��������m�k�*em;$cHz
�����-0 ̻iH�i=�B
�g��@��/!���.�XO�M{Oh�lP��H���:<�¹�c�H,>~+А�ӳ!ɸ�%���J�~�<r�+i�<_ui����`�g<0{�..x���Ǌ�F!��.@��AD=.f����}�ջY��(yTt���\hɀ�,�zU�˥SU"���d��u��,Q��=�������̔�1���E��;@��4��.��c$�TE�l-?�sN �%���5NX����W��l���~�rͦ:xz(~��5��3M�n!�#�^ɭ��hy�Y�a��'\}Wbl�IӀ޻��e��0ZN����>���F��P>�XL>���M��-�{/�m��E��h��ct��`>H�5i%����w-�qE=7<<>e'�|�Ds�SZ{��L��������S�����(��)����7��l�eZ�O��������	E�x��QC^)���)���K	��M �o l{���S�2�kA�$���q7�q|�}6�4	��4�����K0��X]���̈!�l6��U��s��tʖ�4(έ~7m�=�T�4&ڥݙ�O�Z+�n�6�'Ԏ#��:��G�NF�aaȸ�k�<O����%�p�52M�h���a��.$�p ��\���B�����aT�Q#�m�G�;6̮��F�fz��.H���ZN�ul�de�R��o��dA�0\�lI.Xa��"q�s�l樱@�4 �"�8���h� �?�KS9/ƪY�l���ʭM�ß��$.d9#Z����;)-TR��D���ԡ�AJ�|9������q#^Si,ꠣ���w����r�ם�W�(�V!!_l��}�
.�3nziR#,�HN.y��i!#D�L�oҰr�J}_?3��F���s���� ���?����O�ˇ�?6���P��~
�����z�����tz[�9!(�z��y��ʰ��>���P,���9�3��N��k����͕x��pI7�Ej�)�	|7̇"�3Hރz�Y�Z,�c�4�����:T�\�`/��<g�w#�����]Ⱦ~	�Q��o�oW:�!��L�